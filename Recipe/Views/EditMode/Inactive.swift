//
//  Inactive.swift
//  Recipe
//
//  Created by Christopher Wainwright on 30/07/2023.
//

import SwiftUI

struct Inactive: View {
    
    @EnvironmentObject var document: RecipeDocument
    
    var body: some View {
        ScrollView {
            DescriptionView()
//                .padding(.horizontal)
//                .padding(.horizontal)
            IngredientsView()
//                .padding(.horizontal)
            InstructionsView()
//                .padding(.horizontal)
        }
        .padding(.horizontal)
        .toolbar {
            EditButton()
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(
            ZStack {
                Image(uiImage: document.image)
                    .ignoresSafeArea(.all)
                    .scaledToFill()
                Rectangle()
                    .fill(.regularMaterial)
            }
        )
    }
}

struct Inactive_Preview: PreviewProvider {
    static var previews: some View {
        Inactive()
            .environmentObject(RecipeDocument.exampleRecipe)
    }
}

struct Inactive_Empty_Preview: PreviewProvider {
    static var previews: some View {
        Inactive()
            .environmentObject(RecipeDocument.emptyRecipe)
    }
}
