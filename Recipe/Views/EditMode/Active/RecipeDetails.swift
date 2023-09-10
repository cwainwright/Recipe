//
//  DescriptionField.swift
//  Recipe
//
//  Created by Christopher Wainwright on 16/07/2023.
//

import SwiftUI

struct RecipeDetails: View {
    @EnvironmentObject var document: RecipeDocument
    
    @Environment(\.editMode) private var editMode
    @Environment(\.undoManager) var undoManager
    
    var geometry: GeometryProxy
    
    var body: some View {
        Section("Details") {
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
            .frame(minHeight: 100, maxHeight: .infinity)
            if geometry.size.width <= geometry.size.height {
                HStack {
                    ServesStepper()
                    Spacer()
                    Divider()
                    Spacer()
                    DurationStepper()
                }
            } else {
                ServesStepper()
                DurationStepper()
            }
        }
    }
}
//
//struct DescriptionField_Previews: PreviewProvider {
//    static var previews: some View {
//        EditDescription()
//    }
//}
