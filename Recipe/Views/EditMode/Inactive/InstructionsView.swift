//
//  Ingredients.swift
//  Recipe
//
//  Created by Christopher Wainwright on 05/08/2023.
//

import SwiftUI

struct InstructionsView: View {
    @EnvironmentObject var document: RecipeDocument
    
    var body: some View {
        MaterialCard {
            VStack {
                Text("Instructions")
                    .font(.title3)
                if document.recipe.instructions.count == 0 {
                    Text("There are no instructions")
                        .font(.footnote)
                        .foregroundColor(.gray)
                } else {
                    Grid(alignment: .topLeading) {
                        ForEach(Array(document.recipe.instructions.enumerated()), id: \.1.id) { index, instruction in
                            GridRow {
                                Text("\(index+1).")
                                Text(instruction.instruction)
                            }
                            .padding(.vertical, 1)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct InstructionsView_Single_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .environmentObject(RecipeDocument(
                instructions: Instruction.single
            ))
    }
}

struct InstructionsView_Multiple_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .environmentObject(RecipeDocument(
                instructions: Instruction.multiple
            ))
    }
}

struct InstructionsView_Multiline_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .environmentObject(RecipeDocument(
                instructions: Instruction.multiline
            ))
    }
}

struct InstructionsView_Empty_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .environmentObject(RecipeDocument.empty)
    }
}
