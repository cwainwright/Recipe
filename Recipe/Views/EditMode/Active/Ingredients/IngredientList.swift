//
//  IngredientList.swift
//  Recipe
//
//  Created by Christopher Wainwright on 30/08/2023.
//

import SwiftUI

struct IngredientList: View {
    @Environment(\.undoManager) private var undoManager
    @EnvironmentObject var document: RecipeDocument
    
    var body: some View {
        ForEach(document.recipe.ingredients.indices, id: \.self) { index in
            IngredientRow(index: index)
        }
        .onDelete { document.deleteIngredients(offsets: $0, undoManager: undoManager) }
        .onMove { document.moveIngredientsAt(offsets: $0, toOffset: $1, undoManager: undoManager) }
        
        Button("Add Ingredient") {
            withAnimation {
                document.addIngredient(ingredient:Ingredient(), undoManager: undoManager)
            }
        }
    }
}
