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
        if (document.recipe.description != ""){
            MaterialCard {
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.title2)
                    Text(document.recipe.description)
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 1)
                }
                .padding()
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewBackground {
            MaterialCard {
                DescriptionView()
            }
        }
        .environmentObject(RecipeDocument(description: "Hello World"))
        .previewDisplayName("Singleline")
        
        PreviewBackground {
            MaterialCard {
                DescriptionView()
            }
        }
        .environmentObject(RecipeDocument(
            description: """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit,
            sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
            Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
            Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
            Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
            """
        ))
        .previewDisplayName("Multiline")
        
        PreviewBackground {
            MaterialCard {
                DescriptionView()
            }
        }
        .environmentObject(RecipeDocument.empty)
        .previewDisplayName("Empty")
    }
}
