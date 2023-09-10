//
//  ImageView.swift
//  Recipe
//
//  Created by Christopher Wainwright on 08/09/2023.
//

import SwiftUI

struct ImageView: View {
    @EnvironmentObject var document: RecipeDocument
    
    var body: some View {
        MaterialCard {
            ZStack {
                Image(uiImage: document.image)
                    .resizable()
                    .scaledToFill()
                    .draggable(document.image.jpegData(compressionQuality: 1)!)
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        switch(document.recipe.serves) {
                        case 1:
                            Image(systemName: "person")
                        case 2:
                            Image(systemName: "person.2")
                        case 3:
                            Image(systemName: "person.3")
                        default:
                            Image(systemName: "person.line.dotted.person")
                        }
                        Text("Serves: \(document.recipe.serves)")
                        Spacer()
                        Divider()
                            .frame(height: 30)
                        Spacer()
                        Image(systemName: "clock")
                        Text("Time: \(document.recipe.duration_string)")
                        Spacer()
                    }
                    .frame(maxHeight: 50)
                    .background {
                        Rectangle().fill(.regularMaterial)
                    }
                }
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .environmentObject(RecipeDocument.example)
    }
}
