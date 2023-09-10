//
//  Active.swift
//  Recipe
//
//  Created by Christopher Wainwright on 30/07/2023.
//

import SwiftUI

struct Active: View {
    @EnvironmentObject var document: RecipeDocument
    @Environment(\.undoManager) private var undoManager
    
    var geometry: GeometryProxy
    
    @State private var showImageSelector = false
    
    var body: some View {
        VStack {
            // Geometry is Portrait
            if geometry.size.width <= geometry.size.height {
                List {
                    RecipeDetails(geometry: geometry)
                    IngredientList()
                    InstructionList()
                    ImageSelect(showSheet: $showImageSelector)
                }
            } else {
                VStack {
                    HStack {
                        List {
                            RecipeDetails(geometry: geometry)
                            ImageSelect(showSheet: $showImageSelector)
                        }
                        List {
                            IngredientList()
                            InstructionList()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showImageSelector) {
            ImagePicker(selectedImage: Binding(get: {
                document.image
            }, set: { newImage in
                document.registerUndoImageChange(newImage: newImage, undoManager: undoManager)
                document.image = newImage
            }))
        }
        .toolbar {
            Button { undoManager?.undo() } label: {
                Image(systemName: "arrow.uturn.backward.circle")
                    .disabled(!(undoManager?.canUndo ?? false))
            }
        
            Button { undoManager?.redo() } label: {
                Image(systemName: "arrow.uturn.forward.circle")
                    .disabled(!(undoManager?.canRedo ?? false))
            }
            EditButton()
        }
    }
}
