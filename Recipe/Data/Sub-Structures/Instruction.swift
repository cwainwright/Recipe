//
//  Instruction.swift
//  Recipe
//
//  Created by Christopher Wainwright on 26/06/2023.
//

import Foundation

struct Instruction: Codable {
    var id: UUID = UUID()
    var detail: String
}

// default initialiser
extension Instruction {
    init() {
        detail = ""
    }
}

extension Instruction: Equatable {
    static func ==(lhs: Instruction, rhs: Instruction) -> Bool {
        lhs.id == rhs.id
    }
}

extension Instruction {
    static var single: Array<Instruction> = [
        Instruction(detail: "Write one instruction")
    ]
    static var multiple: Array<Instruction> = [
        Instruction(detail: "Write one instruction"),
        Instruction(detail: "Write two instructions!"),
        Instruction(detail: "Write three instructions?!")
    ]
    static var multiline: Array<Instruction> = [
        Instruction(detail: "Write a new instruction with instruction\nWith additional instruction here!")
    ]
    
    static var example: Array<Instruction> = [
        Instruction(detail: "Peel and cut the 2 cooking apples and lay them in the base of your baking tray so that they cover it evenly."),
        Instruction(detail: "Sieve the flour into a mixing bowl and add butter, rub in the butter until you have a sand-like texture."),
        Instruction(detail: "Pour the flour mix over the apples and even out.")
    ]
}
