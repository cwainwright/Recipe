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
                        ServesView()
                            .frame(maxWidth: .infinity)
                        Divider()
                        DurationView()
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
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
        PreviewBackground {
            ImageView()
        }
        .environmentObject(RecipeDocument.example)
        .previewDisplayName("Example")
    }
}
