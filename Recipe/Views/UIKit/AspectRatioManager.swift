//
//  AspectRatioManager.swift
//  Recipe
//
//  Created by Christopher Wainwright on 10/09/2023.
//

import Foundation
import SwiftUI
import UIKit

enum Orientation { case portrait; case landscape}

extension Orientation {
    var isPortrait: Bool {
        self == .portrait
    }
    
    var isLandscape: Bool {
        self == .landscape
    }
}

func aspectRatio(geometry: GeometryProxy) -> Orientation {
    if geometry.size.width <= geometry.size.height {
        return Orientation.portrait
    } else {
        return Orientation.landscape
    }
}
