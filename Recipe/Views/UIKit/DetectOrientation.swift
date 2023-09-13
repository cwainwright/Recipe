//
//  DetectOrientation.swift
//  Recipe
//
//  Created by Christopher Wainwright on 09/09/2023.
//

import SwiftUI
import UIKit

struct DeviceRotationViewModifier: ViewModifier {
    
    let action: (UIDeviceOrientation) -> Void
    let oldOrientation: UIDeviceOrientation
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !UIDevice.current.orientation.isFlat {
                    action(UIDevice.current.orientation)
                } else {
                    print("Orientation is flat: reverting to old orientation: \(oldOrientation)")
                    action(oldOrientation)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                if !UIDevice.current.orientation.isFlat {
                    action(UIDevice.current.orientation)
                } else {
                    print("Orientation is flat: reverting to old orientation: \(oldOrientation)")
                    action(oldOrientation)
                }
            }
    }
}

extension View {
    func onRotate(oldOrientation: UIDeviceOrientation, perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action, oldOrientation: oldOrientation))
    }
}
