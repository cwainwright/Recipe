//
//  InstructionList.swift
//  Recipe
//
//  Created by Christopher Wainwright on 30/08/2023.
//

import SwiftUI

struct InstructionList: View {
    @Environment(\.undoManager) private var undoManager
    @EnvironmentObject var document: RecipeDocument
    
    var body: some View {
        Section("Instructions") {
            ForEach(Array(document.recipe.instructions.indices), id: \.self) { index in
                InstructionRow(index: index)
            }
            .onDelete { document.deleteInstructions(offsets: $0, undoManager: undoManager) }
            .onMove { document.moveInstructionsAt(offsets: $0, toOffset: $1, undoManager: undoManager)}
            
            Button("Add Instruction") {
                withAnimation {
                    document.addInstruction(instruction: Instruction(), undoManager: undoManager)
                }
            }
        }
    }
}
