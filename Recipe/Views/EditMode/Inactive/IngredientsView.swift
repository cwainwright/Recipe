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
        MaterialCard {
            VStack(alignment: .leading) {
                Text("Ingredients")
                    .font(.title2)
                if document.recipe.ingredients.count == 0 {
                    Text("There are no ingredients")
                        .font(.footnote)
                        .foregroundColor(.gray)
                } else {
                    VStack(alignment: .listRowSeparatorLeading) {
                        ForEach(document.recipe.ingredients, id: \.id) { ingredient in
                            HStack (alignment: .firstTextBaseline){
                                Text("\u{2022} ")
                                Text(ingredient.toString())
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.vertical, 1)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct Ingredients_Previews: PreviewProvider {
    static var previews: some View {
        PreviewBackground {
            IngredientsView()
        }
        .environmentObject(RecipeDocument.example)
        .previewDisplayName("Example")
        
        PreviewBackground {
            IngredientsView()
        }
        .environmentObject(RecipeDocument.empty)
        .previewDisplayName("Empty")
    }
}
