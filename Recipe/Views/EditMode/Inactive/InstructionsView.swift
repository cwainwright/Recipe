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
            VStack(alignment: .leading) {
                Text("Instructions")
                    .font(.title2)
                if document.recipe.instructions.count == 0 {
                    Text("There are no instructions")
                        .font(.footnote)
                        .foregroundColor(.gray)
                } else {
                    Grid(alignment: .topLeading) {
                        ForEach(Array(document.recipe.instructions.enumerated()), id: \.1.id) { index, instruction in
                            GridRow(alignment: .firstTextBaseline) {
                                Text("\(index+1).")
                                Text(instruction.instruction)
                                    .multilineTextAlignment(.leading)
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

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewBackground {
            InstructionsView()
        }
        .environmentObject(RecipeDocument(
            instructions: Instruction.single
        ))
        .previewDisplayName("Single")
        
        PreviewBackground {
            InstructionsView()
        }
        .environmentObject(RecipeDocument(
            instructions: Instruction.multiple
        ))
        .previewDisplayName("Multiple")
        
        PreviewBackground {
            ScrollView(.horizontal) {
                InstructionsView()
            }
        }
        .environmentObject(RecipeDocument(
            instructions: Instruction.multiline
        ))
        .previewDisplayName("Multiline")
        
        PreviewBackground {
            InstructionsView()
        }
        .environmentObject(RecipeDocument.empty)
        .previewDisplayName("Empty")
        
    }
}
