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

struct ARVisTableView: View {
    @State var configuration: TableConfiguration

    var body: some View {
        Group {
            let orientation = configuration.orientation
            let tableData = configuration.tableData
            if orientation == .horizontal {
                Divider()
                HStack {
                    ForEach(0 ..< tableData.titles.count, id: \.self) { indexTitle in
                        let title = tableData.titles[indexTitle]
                        Text(title)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                ForEach(0 ..< tableData.length, id: \.self) { index in
                    Divider()
                    HStack {
                        ForEach(0 ..< tableData.titles.count, id: \.self) { indexTitle in
                            let title = tableData.titles[indexTitle]
                            if let value = tableData.data[title].array?[index] {
                                Text(.init("\(value.stringValue)"))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            } else {
                                Text("-")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                }
                Divider()
            } else if orientation == .vertical {
                Divider()
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
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                Text("-")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    Divider()
                }
            }
        }
        .padding()
    }
}
