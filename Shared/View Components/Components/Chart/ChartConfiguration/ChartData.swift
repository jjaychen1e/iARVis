//
//  ChartData.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/27.
//

import Foundation
import SwiftyJSON

struct ChartData: Codable, Equatable {
    var dataItems: [String: ChartDataItem] = [:]

    init(_ dataSources: [JSON] = []) {
        for dataSource in dataSources {
            if let label = dataSource["label"].string {
                dataItems[label] = ChartDataItem(data: dataSource["data"], titles: dataSource["titles"].array?.compactMap { $0.string })
            }
        }
    }
}

struct ChartDataItem: Codable, Equatable {
    private(set) var data: JSON
    private(set) var titles: [String]
    private(set) var length: Int

    init(data: JSON? = nil, titles: [String]? = nil) {
        let data = data ?? JSON()
        self.data = data

        if let titles = titles {
            self.titles = titles
        } else {
            if let keys = data.dictionary?.keys {
                self.titles = Array(keys)
            } else {
                self.titles = []
            }
        }

        var maxLength = 0
        for title in self.titles {
            if let array = data[title].array {
                maxLength = max(maxLength, array.count)
            } else {
                self.data[title] = [data[title]]
                maxLength = max(maxLength, 1)
            }
        }
        length = maxLength
    }
}

extension ChartDataItem {
    func datum(at index: Int) -> JSON {
        var dict: [String: JSON] = [:]
        for title in titles {
            dict[title] = data[title].array?[safe: index]
        }
        return JSON(dict)
    }

    func datumArray() -> [NSDictionary] {
        var resultArray: [NSDictionary] = []

        let titleDataMap = data.object as? NSDictionary ?? [:]
        for i in 0 ..< length {
            let dict = NSMutableDictionary()
            for title in titles {
                if let array = titleDataMap[title] as? [Any] {
                    if let any = array[safe: i] {
                        dict[title] = toSwiftType(any)
                    }
                }
            }
            resultArray.append(dict)
        }
        return resultArray
    }
}
