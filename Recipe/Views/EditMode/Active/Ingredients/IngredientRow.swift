//
//  IngredientView.swift
//  Recipe
//
//  Created by Christopher Wainwright on 16/07/2023.
//

import SwiftUI

struct IngredientRow: View {
    @Environment(\.undoManager) var undoManager
    @EnvironmentObject var document: RecipeDocument
    
    @State var index: Int
    
    @State var measure: String = ""
    @State var measure_valid: Bool = true
    
    var ingredient: Ingredient {
        document.recipe.ingredients[index]
    }
    
    var body: some View {
        HStack{
            if (index < document.recipe.ingredients.count) {
                // Ingredient Input Field
                TextField("Ingredient",
                    text: Binding(get: {
                        ingredient.ingredient
                    }, set: { newValue in
                        let oldValue = ingredient.ingredient
                        document.recipe.ingredients[index].ingredient = newValue
                        document.registerUndoIngredientChange(for: index, newIngredient: newValue, oldIngredient: oldValue, undoManager: undoManager)
                    }),
                    prompt: Text("name")
                )
                
                // Measure Text Input
                TextField("Measure",
                    text: Binding(get: {
                        measure
                    }, set: { newValue in
                        if let newMeasure = Float(newValue) {
                            let oldMeasure = document.recipe.ingredients[index].measure
                            document.recipe.ingredients[index].measure = newMeasure
                            document.registerUndoMeasureChange(for: index, newMeasure: newMeasure, oldMeasure: oldMeasure, undoManager: undoManager)
                            measure_valid = true
                        } else {
                            measure_valid = false
                        }
                        measure = newValue
                    }),
                    prompt: Text("measure")
                )
                .foregroundColor(measure_valid ? .accentColor : .red)
                
                //  Unit Input Field
                TextField(
                    "Unit",
                    text: Binding(get: {
                        ingredient.unit
                    }, set: { newValue in
                        let oldValue = ingredient.unit
                        document.recipe.ingredients[index].unit = newValue
                        document.registerUndoUnitChange(for: index, newUnit: newValue, oldUnit: oldValue, undoManager: undoManager)
                    })
                )
                .textInputAutocapitalization(.never)
            }
        }
        .onAppear {
            // Set initial value of measure (which can be edited like a string)
            measure = String(ingredient.measure)
        }
    }
}
