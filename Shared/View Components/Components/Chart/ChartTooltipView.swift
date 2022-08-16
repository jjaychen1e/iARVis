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
            .overlay(alignment: .topTrailing) {
                Button {
                    let nvc = UINavigationController()
                    nvc.setNavigationBarHidden(true, animated: false)
                    nvc.viewControllers = [UIHostingController(rootView:
                        ComponentView(component)
                            .overlay(alignment: .topTrailing) {
                                Button { [weak nvc] in
                                    if let nvc = nvc {
                                        nvc.dismiss(animated: true)
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                        .padding(.all, 8)
                                        .background(
                                            Circle()
                                                .stroke(Asset.DynamicColors.dynamicWhite.swiftUIColor, lineWidth: 1)
                                                .background(Asset.DynamicColors.dynamicWhite.swiftUIColor)
                                        )
                                        .clipShape(Circle())
                                        .shadow(color: .primary.opacity(0.1), radius: 5)
                                        .offset(x: -16, y: 16)
                                }
                            }
                    )]
                    UIApplication.shared.presentOnTop(nvc, detents: [
                        .custom { context in
                            context.maximumDetentValue * 0.3
                        },
                        .custom { context in
                            context.maximumDetentValue * 0.5
                        },
                        .large(),
                    ])
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
                        .offset(x: -6, y: 6)
                }
            }
    }
}
