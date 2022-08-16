//
//  ChartTooltipView.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/16.
//

import SwiftUI

struct ChartTooltipView: View {
    let component: ViewElementComponent

    init(_ component: ViewElementComponent) {
        self.component = component
    }

    init(_ components: [ViewElementComponent]) {
        if components.count == 0 {
            component = components[0]
        } else {
            component = .vStack(elements: components, alignment: .center)
        }
    }

    var body: some View {
        component.view()
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Asset.DynamicColors.dynamicWhite.swiftUIColor, lineWidth: 1)
                    .background(Asset.DynamicColors.dynamicWhite.swiftUIColor)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .primary.opacity(0.1), radius: 15)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    print("放大")
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.all, 6)
                        .background(
                            Circle()
                                .stroke(Asset.DynamicColors.dynamicWhite.swiftUIColor, lineWidth: 1)
                                .background(Asset.DynamicColors.dynamicWhite.swiftUIColor)
                        )
                        .clipShape(Circle())
                        .shadow(color: .primary.opacity(0.1), radius: 5)
                        .offset(x: -6, y: -6)
                }
            }
    }
}
