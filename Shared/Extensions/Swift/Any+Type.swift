//
//  Any+Type.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/9/2.
//

import Foundation
import SwiftDate

func toSwiftType(_ any: Any) -> Any {
    if let nsNumber = any as? NSNumber {
        return nsNumber.toSwiftType()
    } else if let string = any as? String, let date = string.toDate(String.iARVisAutoFormats, region: SwiftDate.defaultRegion)?.date {
        return date
    } else {
        return any
    }
}
