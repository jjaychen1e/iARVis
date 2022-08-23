//
//  View+Execute.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/16.
//

import Foundation
import SwiftUI

func execute(closure: () -> Void) -> some View {
    closure()
    return Color.clear.opacity(0)
}

func executeAsync(closure: @escaping () -> Void) -> some View {
    DispatchQueue.main.async {
        closure()
    }
    return Color.clear.opacity(0)
}
