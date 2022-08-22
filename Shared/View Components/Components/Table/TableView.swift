//
//  TableView.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/12.
//

import SwiftUI

enum ARVisTableViewOrientation: Codable {
    case horizontal
    case vertical
}

private struct MyDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.3))
            .frame(height: 1)
            .padding(.vertical)
    }
}

struct ARVisTableView: View {
    @State var configuration: TableConfiguration

    var body: some View {
        Group {
            let orientation = configuration.orientation
            let tableData = configuration.tableData
            if orientation == .horizontal {
                VStack(spacing: 0) {
                    MyDivider()
                    HStack {
                        ForEach(0 ..< tableData.titles.count, id: \.self) { indexTitle in
                            let title = tableData.titles[indexTitle]
                            Text(title)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    ForEach(0 ..< tableData.length, id: \.self) { index in
                        MyDivider()
                        HStack {
                            ForEach(0 ..< tableData.titles.count, id: \.self) { indexTitle in
                                let title = tableData.titles[indexTitle]
                                if let value = tableData.data[title].array?[index] {
                                    Text(.init("\(value.stringValue)"))
                                        .fixedSize(horizontal: false, vertical: true)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                } else {
                                    Text("-")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                        }
                    }
                    MyDivider()
                }
                EmptyView()
            } else if orientation == .vertical {
                VStack(spacing: 0) {
                    MyDivider()
                    ForEach(0 ..< tableData.titles.count, id: \.self) { indexTitle in
                        HStack {
                            let title = tableData.titles[indexTitle]
                            Text(title)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)

                            ForEach(0 ..< tableData.length, id: \.self) { index in
                                let title = tableData.titles[indexTitle]
                                if let value = tableData.data[title].array?[index] {
                                    Text(.init("\(value.stringValue)"))
                                        .fixedSize(horizontal: false, vertical: true)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } else {
                                    Text("-")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        MyDivider()
                    }
                }
            }
        }
    }
}
