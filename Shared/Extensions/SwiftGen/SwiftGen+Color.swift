//
//  SwiftGen+Color.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/16.
//

import Foundation
import SwiftUI

extension ColorAsset {
    var swiftUIColor: SwiftUI.Color {
        SwiftUI.Color(uiColor: color)
    }
}
