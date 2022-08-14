//
//  JSON+Type.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/14.
//

import Foundation
import SwiftyJSON
import SwiftDate

extension JSON {
    var date: Date? {
        stringValue.toDate()?.date
    }
}
