//
//  IngredientList.swift
//  Recipe
//
//  Created by Christopher Wainwright on 30/08/2023.
//

import SwiftUI

struct IngredientList: View {
    @EnvironmentObject var document: RecipeDocument
    
    var body: some View {
        Section("Ingredients") {
            ForEach(document.recipe.ingredients.indices, id: \.self) { index in
                IngredientRow(index: index)
            }
            .onDelete(perform: document.deleteIngredients)
            .onMove(perform:document.moveIngredients)
            
            Button("Add Ingredient") {
                withAnimation {
                    document.appendIngredient(Ingredient())
                }
            }
        }
    }
}
