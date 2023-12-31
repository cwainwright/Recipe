//
//  Ingredient.swift
//  Recipe
//
//  Created by Christopher Wainwright on 26/06/2023.
//

import Foundation
import EventKit

struct Ingredient: Codable, Identifiable {
    var id: UUID = UUID()
    var ingredient: String
    var measure: Float
    var unit: String
    
    var hasUnit: Bool {
        unit != ""
    }
}

// default initialiser
extension Ingredient {
    init() {
        self.ingredient = ""
        self.unit = ""
        self.measure = 0.0
    }
}

// equality operator support
extension Ingredient: Equatable {
    static func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.id == rhs.id
    }
}

// to string function (for display)
extension Ingredient {
    func toString() -> String {
        var string_measure: String
        // if float is int
        if Float(Int(self.measure)) == self.measure {
            string_measure = "\(Int(measure))"
        } else {
            string_measure = "\(measure)"
        }
        // if unit is not empty
        if self.hasUnit {
            return "\(string_measure) \(unit) of \(ingredient)"
        }
        return "\(string_measure) \(ingredient)"
    }
}

// export to reminders
extension Ingredient {
    func toReminder(eventStore: EKEventStore, calendar: EKCalendar) throws {
        
        // create Reminder
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = toString()
        reminder.calendar = calendar
        
        // try to save to calendar
        try eventStore.save(reminder, commit: false)
    }
}

// example array
extension Ingredient {
    static var example: Array<Ingredient> = [
        Ingredient(ingredient: "Apples", measure: 2, unit: ""),
        Ingredient(ingredient: "Flour", measure: 500, unit: "g"),
        Ingredient(ingredient: "Butter", measure: 50, unit: "g"),
        Ingredient(ingredient: "Sugar", measure: 250, unit: "g")
    ]
}
