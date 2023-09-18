//
//  NumericTextField.swift
//  Recipe
//
//  Created by Christopher Wainwright on 07/09/2023.
//

import SwiftUI

protocol StringInitialisable {
    init?(_ _: String)
}

extension Int: StringInitialisable {}
extension Float: StringInitialisable {}
extension Double: StringInitialisable {}

struct NumericTextField<T: Equatable & StringInitialisable>: View {
    let title: String
    let prompt: String
    @Binding var data: T
    let update: (T) -> Void
    
    @State var text: String = ""
    @State var valid: Bool = true
    
    var body: some View {
        TextField(title,
            text: Binding(get: {
                text
            }, set: { newValue in
                if let newData = T.init(newValue) {
                    let oldData = data
                    data = newData
                    update(newData)
                    valid = true
                } else {
                    valid = false
                }
                text = newValue
            }),
            prompt: Text(prompt)
        )
        .foregroundColor(valid ? .accentColor : .red)
        .onAppear {
            // Set initial value of data
            text = "\(data)"
        }
    }
}
