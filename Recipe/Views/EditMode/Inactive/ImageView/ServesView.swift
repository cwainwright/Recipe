//
//  ServesView.swift
//  Recipe
//
//  Created by Christopher Wainwright on 10/09/2023.
//

import SwiftUI

struct ServesView: View {
    @EnvironmentObject var document: RecipeDocument
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack {
                Image(systemName: document.recipe.serves_image)
                Text("Serves: \(document.recipe.serves)")
            }
            VStack {
                Image(systemName: document.recipe.serves_image)
                Text("Serves: \(document.recipe.serves)")
            }
            VStack {
                Image(systemName: document.recipe.serves_image)
                Text("\(document.recipe.serves)")
            }
        }
    }
}

struct ServesView_Previews: PreviewProvider {
    @State var width: CGFloat = 300
    
    static var previews: some View {
        PreviewBackground {
            MaterialCard {
                ServesView()
                    .padding()
            }
            MaterialCard {
                ServesView()
                    .padding()
            }
            .frame(width: 120)
            MaterialCard {
                ServesView()
                    .padding()
            }
            .frame(width: 100)
        }
        .environmentObject(RecipeDocument.example)
    }
}
