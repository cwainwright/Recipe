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
        VStack {
            // Geometry is Portrait
            ViewThatFits {
                VStack {
                    HStack {
                        List {
                            RecipeDetails()
                            ImageSelect(showSheet: $showImageSelector)
                        }
                        List {
                            IngredientList()
                            InstructionList()
                        }
                    }
                }
                .frame(minWidth: 500)
                List {
                    RecipeDetails()
                    IngredientList()
                    InstructionList()
                    ImageSelect(showSheet: $showImageSelector)
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

struct Active_Preview: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .environment(\.editMode, Binding.constant(EditMode.active))
            .environmentObject(RecipeDocument.example)
    }
}

struct Active_Empty_Preview: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .environment(\.editMode, Binding.constant(EditMode.active))
            .environmentObject(RecipeDocument.empty)
    }
}
