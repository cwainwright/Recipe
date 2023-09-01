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
            Active().environmentObject(document)
        } else {
            Inactive().environmentObject(document)
        }
    }
}
