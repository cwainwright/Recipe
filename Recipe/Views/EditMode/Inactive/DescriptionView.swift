//
//  DescriptionView.swift
//  Recipe
//
//  Created by Christopher Wainwright on 05/08/2023.
//

import SwiftUI

struct DescriptionView: View {
    @EnvironmentObject var document: RecipeDocument
    
    var body: some View {
        VStack {
            Image(uiImage: document.image)
                .resizable()
                .scaledToFill()
                .frame(maxHeight: 200)
                .clipped()
                .cornerRadius(5)
            if (document.recipe.description != ""){
                ScrollView {
                    Text(document.recipe.description)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

struct DescriptionView_Multiline_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .environmentObject(RecipeDocument(
                description: """
                Lorem ipsum dolor sit amet, consectetur adipiscing elit,
                sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
                Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
                Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
                Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                """
            ))
    }
}

struct DescriptionView_SingleLine_Preview: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .environmentObject(RecipeDocument(description: "Hello World"))
    }
}

struct DescriptionView_Empty_Preview: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .environmentObject(RecipeDocument.emptyRecipe)
    }
}
