//
//  InstructionList.swift
//  Recipe
//
//  Created by Christopher Wainwright on 30/08/2023.
//

import SwiftUI

struct InstructionList: View {
    @EnvironmentObject var document: RecipeDocument
    
    var body: some View {
        Section("Instructions") {
            ForEach(Array(document.recipe.instructions.indices), id: \.self) { index in
                InstructionRow(index: index)
            }
            .onDelete(perform: document.deleteInstructions)
            .onMove(perform: document.moveInstructions)
            
            Button("Add Instruction") {
                withAnimation {
                    document.appendInstruction(Instruction())
                }
            }
        }
    }
}
