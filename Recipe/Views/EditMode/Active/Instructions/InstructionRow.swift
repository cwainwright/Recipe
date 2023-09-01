//
//  InstructionRow.swift
//  Recipe
//
//  Created by Christopher Wainwright on 05/08/2023.
//

import SwiftUI

struct InstructionRow: View {
    @Environment(\.undoManager) var undoManager
    @EnvironmentObject var document: RecipeDocument
    
    @State var index: Int
    
    var body: some View {
        HStack {
            if index < document.recipe.instructions.count {
                Text("\(index+1)")
                TextField("Instruction",
                    text: Binding(get: {
                        document.recipe.instructions[index].instruction
                    }, set: { newValue in
                        let oldValue = document.recipe.instructions[index].instruction
                        document.recipe.instructions[index].instruction = newValue
                        document.registerUndoInstructionChange(for: index, newInstruction: newValue, oldInstruction: oldValue, undoManager: undoManager)
                    }),
                    prompt: Text("Instruction"))
            }
        }
    }
}
