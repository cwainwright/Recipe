//
//  Recipe.swift
//  Recipe
//
//  Created by Christopher Wainwright on 26/06/2023.
//

import Foundation
import UIKit
import SwiftUI


struct Recipe {
    var description: String
    var duration: Int
    var serves: Int
    var instructions: Array<Instruction>
    var ingredients: Array<Ingredient>
    var utensils: Array<Utensil>
}

extension Recipe {
    enum defaults {
        static let description: String = ""
        static let duration: Int = 30
        static let serves: Int = 4
        static let instructions: Array<Instruction> = []
        static let ingredients: Array<Ingredient> = []
        static let utensils: Array<Utensil> = []
    }
}

// default initialiser
extension Recipe {
    init() {
        self.description = defaults.description
        self.duration = defaults.serves
        self.serves = defaults.duration
        self.instructions = defaults.instructions
        self.ingredients = defaults.ingredients
        self.utensils = defaults.utensils
    }
}

extension Recipe: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? defaults.description
        duration = try container.decodeIfPresent(Int.self, forKey: .duration) ?? defaults.duration
        serves = try container.decodeIfPresent(Int.self, forKey: .serves) ?? defaults.serves
        instructions = try container.decodeIfPresent(Array<Instruction>.self, forKey: .instructions) ?? defaults.instructions
        ingredients = try container.decodeIfPresent(Array<Ingredient>.self, forKey: .ingredients) ?? defaults.ingredients
        utensils = try container.decodeIfPresent(Array<Utensil>.self, forKey: .utensils) ?? defaults.utensils
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
        duration: 30, serves: 4,
        instructions: Instruction.example,
        ingredients: Ingredient.example,
        utensils: Utensil.example
    )
}

// Serves and Duration Computed Properties
extension Recipe {
    var serves_string: String {
        switch serves{
        case 1:
            return "\(serves) person"
        default:
            return "\(serves) people"
        }
    }
    
    var duration_string: String {
        let mins = duration%60 > 1 ? "mins" : "min"
        let hours = Int(duration/60) > 1 ? "hours" : "hour"
        
        if duration < 60 {
            return "\(duration) \(mins)"
        } else if duration % 60 == 0 {
            return "\(Int(duration/60)) \(hours)"
        } else {
            return "\(Int(duration/60)) \(hours), \(duration%60) \(mins)"
        }
    }
}
