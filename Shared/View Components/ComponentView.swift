//
//  ComponentView.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/11.
//

import Foundation
import SwiftUI

struct ComponentView: View {
    let component: ViewElementComponent
    let isScrollEnabled: Bool

    init(_ component: ViewElementComponent, isScrollEnabled: Bool = true) {
        self.component = component
        self.isScrollEnabled = isScrollEnabled
    }

    init(_ components: [ViewElementComponent], isScrollEnabled: Bool = true) {
        if components.count == 1 {
            component = components[0]
        } else {
            component = .vStack(elements: components, alignment: .center)
        }
        self.isScrollEnabled = isScrollEnabled
    }

    var body: some View {
        ScrollView(isScrollEnabled ? .vertical : []) {
            component.view()
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.vertical)
                .padding(.horizontal)
        }
        .coordinateSpace(name: "Widget")
    }
}

struct ComponentView_Previews: PreviewProvider {
    static var previews: some View {
        ComponentView(.example3_AreaChartMatrix)
            .previewLayout(.fixed(width: 2048, height: 1680))
    }
}
