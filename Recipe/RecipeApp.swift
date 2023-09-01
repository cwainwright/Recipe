//
//  RecipeApp.swift
//  Recipe
//
//  Created by Christopher Wainwright on 26/06/2023.
//

import SwiftUI

@main
struct RecipeApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: { RecipeDocument() }) { file in
            RecipeView()
        }
    }
}
