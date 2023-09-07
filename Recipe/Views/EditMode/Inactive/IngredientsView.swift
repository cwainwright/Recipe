//
//  Ingredients.swift
//  Recipe
//
//  Created by Christopher Wainwright on 05/08/2023.
//

import SwiftUI

struct IngredientsView: View {
    @EnvironmentObject var document: RecipeDocument
    
    var body: some View {
        VStack {
            Text("Ingredients")
                .font(.title3)
                .frame(alignment: .leading)
            if document.recipe.ingredients.count == 0 {
                Text("There are no ingredients")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .frame(alignment: .leading)
            } else {
                Grid(alignment: .topLeading) {
                    ForEach(document.recipe.ingredients, id: \.id) { ingredient in
                        GridRow {
                            Text(ingredient.toList())
                        }
                        .padding(.vertical, 1)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

struct Ingredients_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .environmentObject(RecipeDocument(
                description: "A Description",
                ingredients: Ingredient.example,
                instructions: [],
                utensils: []
            ))
    }
}
