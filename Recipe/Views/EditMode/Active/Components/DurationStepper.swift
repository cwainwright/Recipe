//
//  TimeStepper.swift
//  Recipe
//
//  Created by Christopher Wainwright on 09/09/2023.
//

import SwiftUI

struct DurationStepper: View {
    @EnvironmentObject var document: RecipeDocument
    @Environment(\.undoManager) var undoManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Stepper(
                "Time: \(document.recipe.duration_string)",
                onIncrement: {
                    if document.recipe.duration >= 720 {
                        document.recipe.duration = 720
                        return
                    }
                    document.registerUndoDurationChange(oldValue: document.recipe.duration, newValue: document.recipe.duration+1, undoManager: undoManager)
                    document.recipe.duration += 1
                }, onDecrement: {
                    if document.recipe.duration <= 1 {
                        document.recipe.duration = 1
                        return
                    }
                    document.registerUndoDurationChange(oldValue: document.recipe.duration, newValue: document.recipe.duration-1, undoManager: undoManager)
                    document.recipe.duration -= 1
                }
            )
            .frame(maxWidth: 280)
        }
    }
}

struct DurationStepper_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MaterialCard {
                DurationStepper()
                    .environmentObject(RecipeDocument.example)
            }
            .padding()
        }
    }
}
