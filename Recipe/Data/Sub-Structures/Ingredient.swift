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
    var name: String
    var measure: Float
    var unit: String
    
    var hasUnit: Bool {
        unit != ""
    }
}

// default initialiser
extension Ingredient {
    init() {
        self.name = ""
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
            return "\(string_measure) \(unit) of \(name)"
        }
        return "\(string_measure) \(name)"
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
        Ingredient(name: "Apples", measure: 2, unit: ""),
        Ingredient(name: "Flour", measure: 500, unit: "g"),
        Ingredient(name: "Butter", measure: 50, unit: "g"),
        Ingredient(name: "Sugar", measure: 250, unit: "g")
    ]
}
