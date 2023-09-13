//
//  PreviewBackground.swift
//  Recipe
//
//  Created by Christopher Wainwright on 10/09/2023.
//

import SwiftUI

struct PreviewBackground<Content: View>: View {
    var content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ScrollView(content: content)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background {
            ZStack {
                Image("food_example")
                Rectangle().fill(.thinMaterial)
            }
        }
    }
}

struct PreviewBackground_Previews: PreviewProvider {
    static var previews: some View {
        PreviewBackground() {
            Text("Hello World")
        }
        .previewDisplayName("Hello World")
        
        PreviewBackground() {
        }
        .previewDisplayName("Empty")
    }
}
