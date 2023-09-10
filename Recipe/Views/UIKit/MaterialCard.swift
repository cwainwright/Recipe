//
//  MaterialCard.swift
//  Recipe
//
//  Created by Christopher Wainwright on 09/09/2023.
//

import SwiftUI

struct MaterialCard<Content: View>: View {
    var content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack(content: content)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct MaterialCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MaterialCard {
                Text("Hello World")
                    .padding()
            }
        }
        .padding()
        .background{
            ZStack {
                Image("food_example")
                Rectangle().fill(.thinMaterial)
            }
        }
    }
}
