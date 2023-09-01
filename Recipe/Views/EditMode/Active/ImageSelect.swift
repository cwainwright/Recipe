//
//  ImageSelect.swift
//  Recipe
//
//  Created by Christopher Wainwright on 01/09/2023.
//

import SwiftUI

struct ImageSelect: View {
    @Binding var showSheet: Bool
    
    @EnvironmentObject var document: RecipeDocument
    
    var body: some View {
        Button {
            showSheet.toggle()
        } label: {
            VStack(alignment: .center) {
                Image(systemName: "photo")
                Text("Select Photo")
            }
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    Image(uiImage: document.image)
                        .scaledToFill()
                    Rectangle()
                        .fill(.regularMaterial)
                }
            )
        }
        .frame(idealHeight: 50)
        Image(uiImage: document.image)
            .resizable()
            .scaledToFill()
            .cornerRadius(5)
            .padding()
    }
}

struct ImageSelect_Previews: PreviewProvider {
    @State static var showSheet: Bool = false
    static var previews: some View {
        ImageSelect(showSheet: $showSheet)
            .environmentObject(RecipeDocument.exampleRecipe)
    }
}
