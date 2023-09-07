//
//  Recipe.swift
//  Recipe
//
//  Created by Christopher Wainwright on 26/06/2023.
//

import Foundation
import UIKit
import SwiftUI

struct Recipe: Codable {
    var description: String
//    var duration: Int
//    var serves: Int
    var instructions: Array<Instruction>
    var ingredients: Array<Ingredient>
    var utensils: Array<Utensil>
}

// default initialiser
extension Recipe {
    init() {
        self.description = ""
//        self.duration = 1
//        self.serves = 1
        self.instructions = []
        self.ingredients = []
        self.utensils = []
    }
}

// example recipes
extension Recipe {
    /// empty recipe
    static var empty = Recipe()
    
    /// example recipe
    static var example = Recipe(
        description: """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit,
        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
        Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
        Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
        Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """,
//        duration: 30, serves: 1,
        instructions: Instruction.example,
        ingredients: Ingredient.example,
        utensils: Utensil.example
    )
}
