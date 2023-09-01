//
//  IngredientView.swift
//  Recipe
//
//  Created by Christopher Wainwright on 16/07/2023.
//

import SwiftUI

struct IngredientRow: View {
    
    @State var ingredient_index: Int
    @Environment(\.undoManager) var undoManager
    @EnvironmentObject var document: RecipeDocument
    
    var body: some View {
        HStack{
            Button {
                document.toggleIngredientUnit(document.recipe.ingredients[ingredient_index])
            } label: {
                Image(systemName: document.recipe.ingredients[ingredient_index].hasUnit ? "checkmark.circle" : "circle")
            }
            .buttonStyle(BorderlessButtonStyle())
            TextEditor(text: Binding(
                get: {
                    document.recipe.ingredients[ingredient_index].ingredient
                },
                set: { newDescription in
                    let oldDescription = document.recipe.description
                    document.recipe.description = newDescription
                    document.registerUndoDescriptionChange(newDescription: newDescription, oldDescription: oldDescription, undoManager: undoManager)
                }
            ))
        }
        
    }
}

struct IngredientView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientRow(ingredient_index: 1)
            .environmentObject(RecipeDocument())
    }
}
