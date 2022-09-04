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

    mutating func update(typeInformation: [String: [String: ARVisPlottableValueTypeInformation]] = [:]) {
        var newDataItems: [String: ChartDataItem] = [:]
        for (label, dataItem) in dataItems {
            if let typeInformation = typeInformation[label] {
                var _dataItem = dataItem
                _dataItem.typeInformation = typeInformation
                newDataItems[label] = _dataItem
            } else {
                newDataItems[label] = dataItem
            }
        }
        dataItems = newDataItems
    }
}

struct ChartDataItem: Codable, Equatable {
    private(set) var data: JSON
    private(set) var titles: [String]
    private(set) var length: Int

    private(set) var datumArray: [NSDictionary] = []

    fileprivate var typeInformation: [String: ARVisPlottableValueTypeInformation] = [:] {
        didSet {
            generateDatumArray()
        }
    }

    enum CodingKeys: CodingKey {
        case data
        case titles
        case length
    }

    mutating func generateDatumArray() {
        var datumArray: [NSDictionary] = []
        let titleDataMap = data.object as? NSDictionary ?? [:]
        for i in 0 ..< length {
            let dict = NSMutableDictionary()
            for title in titles {
                if let array = titleDataMap[title] as? [Any] {
                    if let any = array[safe: i] {
                        if let typeInformation = typeInformation[title] {
                            switch typeInformation {
                            case let .date(format: format):
                                if let string = any as? String {
                                    dict[title] = AutoDateParser.shared.parse(string, format: format)
                                } else if let nsNumber = any as? NSNumber {
                                    dict[title] = AutoDateParser.shared.parse(nsNumber.stringValue, format: format)
                                } else {
                                    dict[title] = toSwiftType(any)
                                }
                            }
                        } else {
                            dict[title] = toSwiftType(any)
                        }
                    }
                }
            }
            datumArray.append(dict)
        }
        self.datumArray = datumArray
    }

    init(data: JSON? = nil, titles: [String]? = nil, typeInformation: [String: ARVisPlottableValueTypeInformation] = [:]) {
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
        self.typeInformation = typeInformation
        generateDatumArray()
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
}
