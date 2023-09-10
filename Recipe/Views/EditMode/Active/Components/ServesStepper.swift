//
//  TimeStepper.swift
//  Recipe
//
//  Created by Christopher Wainwright on 09/09/2023.
//

import SwiftUI

struct ServesStepper: View {
    @EnvironmentObject var document: RecipeDocument
    @Environment(\.undoManager) var undoManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Stepper(
                "Serves: \(document.recipe.serves_string)",
                onIncrement: {
                    if document.recipe.serves >= 25 {
                        document.recipe.serves = 25
                        return
                    }
                    document.registerUndoServesChange(oldValue: document.recipe.serves, newValue: document.recipe.serves+1, undoManager: undoManager)
                    document.recipe.serves += 1
                }, onDecrement: {
                    if document.recipe.serves <= 1 {
                        document.recipe.serves = 1
                        return
                    }
                    document.registerUndoServesChange(oldValue: document.recipe.serves, newValue: document.recipe.serves-1, undoManager: undoManager)
                    document.recipe.serves -= 1
                }
            )
            .frame(maxWidth: 280)
        }
    }
}

struct ServesStepper_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MaterialCard {
                ServesStepper()
                    .environmentObject(RecipeDocument.example)
            }
            .padding()
        }
    }
}
