//
//  IngredientView.swift
//  Recipe
//
//  Created by Christopher Wainwright on 16/07/2023.
//

import SwiftUI

struct IngredientRow: View {
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
                        ingredient.name
                    }, set: { newValue in
                        document.setIngredientName(of: index, to: newValue)
                    }),
                    prompt: Text("name")
                )
                
                // Measure Text Input
                NumericTextField(title: "Measure", prompt: "measure", data: $document.recipe.ingredients[index].measure) {
                    document.setIngredientMeasure(of: index, to: $0)
                }
                
                //  Unit Input Field
                TextField(
                    "Unit",
                    text: Binding(get: {
                        ingredient.unit
                    }, set: { newValue in
                        document.setIngredientUnit(of: index, to: newValue)
                    })
                )
                .textInputAutocapitalization(.never)
            }
        }
    }
}
