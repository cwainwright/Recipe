//
//  Equipment.swift
//  Recipe
//
//  Created by Christopher Wainwright on 10/08/2023.
//

import Foundation

struct Utensil: Codable, Identifiable {
    var id: UUID = UUID()
    var utensil: String
    var detail: String
}

// default initialiser
extension Utensil {
    init() {
        self.utensil = ""
        self.detail = ""
    }
}

// example array
extension Utensil {
    static var example: Array<Utensil> = [
        Utensil(utensil: "Whisk", detail: ""),
        Utensil(utensil: "Mixing Bowl", detail: "")
    ]
}
