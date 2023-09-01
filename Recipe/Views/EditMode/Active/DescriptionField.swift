//
//  DescriptionField.swift
//  Recipe
//
//  Created by Christopher Wainwright on 16/07/2023.
//

import SwiftUI

struct DescriptionField: View {
    @EnvironmentObject var document: RecipeDocument
    
    @Environment(\.editMode) private var editMode
    @Environment(\.undoManager) var undoManager
    
    var body: some View {
        TextEditor(text: Binding(
            get: {
                document.recipe.description
            },
            set: { newDescription in
                let oldDescription = document.recipe.description
                document.recipe.description = newDescription
                document.registerUndoDescriptionChange(newDescription: newDescription, oldDescription: oldDescription, undoManager: undoManager)
            }
        ))
        .frame(height: 200)
    }
}
//
//struct DescriptionField_Previews: PreviewProvider {
//    static var previews: some View {
//        EditDescription()
//    }
//}
