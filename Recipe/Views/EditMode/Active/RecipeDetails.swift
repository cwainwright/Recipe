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
            .frame(height: 250)
            HStack {
                VStack {
                    ViewThatFits {
                        Text("Serves: \(document.recipe.serves_string)")
                        Text("Serves:\n\(document.recipe.serves_string)")
                    }
                    Stepper(value: Binding(
                        get: {
                            document.recipe.serves
                        },
                        set: {newValue in
                            let oldValue = document.recipe.serves
                            document.registerUndoServesChange(oldValue: oldValue, newValue: newValue, undoManager: undoManager)
                            document.recipe.serves = newValue
                        }
                    ), in: 1...50, step: 1) {
                        Text("Serves: \(document.recipe.serves_string)")
                    }
                    .labelsHidden()
                }
                Spacer()
                Divider()
                Spacer()
                VStack {
                    ViewThatFits {
                        Text("Duration: \(document.recipe.durationString)")
                        Text("Duration:\n\(document.recipe.durationString)")
                        Text("Duration:\n\(document.recipe.durationHoursString)\(document.recipe.durationMinsString)")
                    }
                    Stepper(value: Binding(
                        get: {
                            document.recipe.duration
                        },
                        set: {newValue in
                            let oldValue = document.recipe.duration
                            document.registerUndoDurationChange(oldValue: oldValue, newValue: newValue, undoManager: undoManager)
                            document.recipe.duration = newValue
                        }
                    ), in: 1...720, step: 1) {
                        Text("Duration: \(document.recipe.durationString)")
                    }
                    .labelsHidden()
                }
            }
        }
    }
}

struct RecipeDetails_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RecipeDetails()
        }
        .environmentObject(RecipeDocument.example)
    }
}
