//
//  View+Execute.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/16.
//

import Foundation
import SwiftUI

extension View {
    func execute(closure: () -> Void) -> some View {
        closure()
        return self.background(Color.clear.opacity(0))
    }

    func executeAsync(closure: @escaping () -> Void) -> some View {
        DispatchQueue.main.async {
            closure()
        }
        return self.background(Color.clear.opacity(0))
    }
}
