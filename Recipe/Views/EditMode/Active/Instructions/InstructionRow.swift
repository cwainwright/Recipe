//
//  InstructionRow.swift
//  Recipe
//
//  Created by Christopher Wainwright on 05/08/2023.
//

import SwiftUI

struct InstructionRow: View {
    @EnvironmentObject var document: RecipeDocument
    
    @State var index: Int
    
    var body: some View {
        HStack {
            if index < document.recipe.instructions.count {
                Text("\(index+1)")
                TextField("Instruction",
                    text: Binding(get: {
                        document.recipe.instructions[index].detail
                    }, set: { newValue in
                        document.setInstructionDetail(of: index, to: newValue)
                    }),
                    prompt: Text("Instruction"))
            }
        }
    }
}
