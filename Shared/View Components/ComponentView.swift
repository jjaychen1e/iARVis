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

    init(_ component: ViewElementComponent) {
        self.component = component
    }

    init(_ components: [ViewElementComponent]) {
        if components.count == 1 {
            component = components[0]
        } else {
            component = .vStack(elements: components, alignment: .center)
        }
    }

    var body: some View {
        ScrollView {
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
        ComponentView(.exampleJamesEnsorWidget)
            .previewLayout(.fixed(width: 1024, height: 768))
    }
}
