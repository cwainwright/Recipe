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
        GeometryReader { geometry in
            VStack {
                if editMode?.wrappedValue == .active {
                    Active(geometry: geometry)
                } else {
                    Inactive(geometry: geometry)
                }
            }
        }
    }
}
