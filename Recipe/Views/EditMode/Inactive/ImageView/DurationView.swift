//
//  DurationView.swift
//  Recipe
//
//  Created by Christopher Wainwright on 10/09/2023.
//

import SwiftUI

struct DurationView: View {
    @EnvironmentObject var document: RecipeDocument
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack {
                Image(systemName: "clock")
                Text("Time: \(document.recipe.duration_string)")
            }
            VStack {
                Image(systemName: "clock")
                Text("Time: \(document.recipe.duration_string)")
            }
            VStack {
                Image(systemName: "clock")
                Text(document.recipe.duration_string)
            }
            Text(document.recipe.duration_string)
        }
    }
}

struct DurationView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewBackground {
            MaterialCard {
                DurationView()
                    .padding()
            }
            MaterialCard {
                DurationView()
                    .padding()
            }
            .frame(width: 120)
            MaterialCard {
                DurationView()
                    .padding()
            }
            .frame(width: 100)
        }
        .environmentObject(RecipeDocument.example)
    }
}
