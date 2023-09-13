//
//  ContentView.swift
//  Recipe
//
//  Created by Christopher Wainwright on 26/06/2023.
//

import SwiftUI

struct RecipeView: View {
    @EnvironmentObject var document: RecipeDocument
    
    @Environment(\.editMode) private var editMode
    @Environment(\.undoManager) private var undoManager
    
    var body: some View {
        if editMode?.wrappedValue == .active {
            Active()
        } else {
            Inactive()
        }
    }
}
struct ExampleRecipeView_Previews: PreviewProvider {
    static var previews: some View {
            RecipeView()
                .environmentObject(RecipeDocument.example)
                .previewDisplayName("View")
            RecipeView()
                .environmentObject(RecipeDocument.example)
                .environment(\.editMode, Binding.constant(EditMode.active))
                .previewDisplayName("Edit")
    }
}
