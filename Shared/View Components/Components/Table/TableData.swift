//
//  TableData.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/12.
//

import Foundation
import SwiftyJSON

struct TableData: Codable, Equatable {
    let data: JSON
    let titles: [String]
    let length: Int
    
    init(data: JSON, titles: [String]? = nil) {
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
            }
        }
        length = maxLength
    }
}

extension TableData {
    static let example1 = TableData(data: [
        "Given Name": ["Juan", "Mei", "Tom", "Gita"],
        "Family Name": ["Chavez", "Chen", "Clark", "Kumar"],
        "E-Mail Address": ["juanchavez@icloud.com", "meichen@icloud.com", "tomclark@icloud.com", "gitakumar@icloud.com"],
        "Age": [21, 22, 29, 32],
        "Description": ["No description", "No description", "[Personal homepage](https://google.com)", "No description"],
    ])
}
