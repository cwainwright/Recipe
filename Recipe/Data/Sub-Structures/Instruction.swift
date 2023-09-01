//
//  Instruction.swift
//  Recipe
//
//  Created by Christopher Wainwright on 26/06/2023.
//

import Foundation

struct Instruction: Codable {
    var id: UUID = UUID()
    var instruction: String
}

// default initialiser
extension Instruction {
    init() {
        instruction = ""
    }
}

extension Instruction: Equatable {
    static func ==(lhs: Instruction, rhs: Instruction) -> Bool {
        lhs.id == rhs.id
    }
}

extension Instruction {
    static var single: Array<Instruction> = [
        Instruction(instruction: "Write one instruction")
    ]
    static var multiple: Array<Instruction> = [
        Instruction(instruction: "Write one instruction"),
        Instruction(instruction: "Write two instructions!"),
        Instruction(instruction: "Write three instructions?!")
    ]
    static var multiline: Array<Instruction> = [
        Instruction(instruction: "Write a new instruction with detail\nWith additional detail here!")
    ]
    
    static var example: Array<Instruction> = [
        Instruction(instruction: "Peel and cut the 2 cooking apples and lay them in the base of your baking tray so that they cover it evenly."),
        Instruction(instruction: "Sieve the flour into a mixing bowl and add butter, rub in the butter until you have a sand-like texture."),
        Instruction(instruction: "Pour the flour mix over the apples and even out.")
    ]
}
