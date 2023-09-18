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
                        ForEach(document.recipe.instructions, id: \.id) { instruction in
                            GridRow(alignment: .firstTextBaseline) {
                                Text("\((document.recipe.instructions.firstIndex(of: instruction) ?? 0)+1).")
                                Text(instruction.detail)
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
