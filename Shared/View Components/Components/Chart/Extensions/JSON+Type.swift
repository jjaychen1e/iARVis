//
//  JSON+Type.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/14.
//

import Foundation
import SwiftDate
import SwiftyJSON

extension JSON {
    var date: Date? {
        stringValue.toDate(String.iARVisAutoFormats, region: SwiftDate.defaultRegion)?.date
    }
}

extension String {
    static let iARVisAutoFormats: [String] = [
        DateFormats.iso8601,
        "yyyy'-'MM'-'dd'T'HH':'mm':'ssZ",
        "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ",
        "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
        "yyyy-MM-dd HH:mm:ss",
        "yyyy-MM-dd HH:mm",
        "yyyy-MM-dd",
        "h:mm:ss A",
        "h:mm A",
        "MM/dd/yyyy",
        "MMMM d, yyyy",
        "MMMM d, yyyy LT",
        "dddd, MMMM D, yyyy LT",
        "yyyyyy-MM-dd",
        "yyyy-MM-dd",
        "yyyy-'W'ww-E",
        "GGGG-'['W']'ww-E",
        "yyyy-'W'ww",
        "GGGG-'['W']'ww",
        "yyyy'W'ww",
        "yyyy-ddd",
        "HH:mm:ss.SSSS",
        "HH:mm:ss",
        "HH:mm",
    ]
}
