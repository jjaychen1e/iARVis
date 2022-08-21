//
//  WidgetConfiguration.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/19.
//

import Foundation

class WidgetConfiguration: Codable {
    var components: [ViewElementComponent]
    
    init(component: ViewElementComponent) {
        self.components = [component]
    }
    
    init(components: [ViewElementComponent] = []) {
        self.components = components
    }
}
