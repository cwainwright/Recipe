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
    
    @State private var showImageSelector = false
    
    var body: some View {
        List {
            Section("Description") {
                DescriptionField()
            }
            Section("Ingredients") {
                IngredientList()
            }
            Section("Instructions") {
                InstructionList()
            }
            Section("Image") {
                ImageSelect(showSheet: $showImageSelector)
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
        .navigationBarTitleDisplayMode(.automatic)
    }
}
