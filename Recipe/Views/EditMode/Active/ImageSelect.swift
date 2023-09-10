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
        Section("Image") {
            MaterialCard {
                ZStack {
                    Image(uiImage: document.image)
                        .resizable()
                        .scaledToFill()
                    VStack {
                        Button {
                            showSheet.toggle()
                        } label: {
                            VStack(alignment: .center) {
                                Image(systemName: "photo")
                                Text("Select Photo")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding([.vertical], 3)
                        .background {
                            Rectangle().fill(
                                .regularMaterial
                            )
                        }
                        Spacer()
                    }
                }
            }
            .padding([.vertical], 4)
        }
    }
}

struct ImageSelect_Previews: PreviewProvider {
    @State static var showSheet: Bool = false
    static var previews: some View {
        List {
            ImageSelect(showSheet: $showSheet)
                .environmentObject(RecipeDocument.example)
        }
    }
}
