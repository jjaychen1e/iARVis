//
//  ARVisSegmentedControlView.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/21.
//

import SwiftUI

struct ARVisSegmentedControlView: View {
    @State private var selectedColorIndex = 0
    @State var items: [ARVisSegmentedControlItem]

    var body: some View {
        VStack {
            Picker("", selection: $selectedColorIndex, content: {
                ForEach(Array(zip(items.indices, items)), id: \.0) { index, item in
                    Text(item.title).tag(index)
                }
            })
            .pickerStyle(SegmentedPickerStyle())
            .frame(minWidth: CGFloat(items.count) * 70)
            .fixedSize()
            if let component = items[safe: selectedColorIndex]?.component {
                component.view()
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
