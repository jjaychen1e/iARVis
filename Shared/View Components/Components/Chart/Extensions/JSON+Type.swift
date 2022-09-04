//
//  JSON+Type.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/14.
//

import Foundation
import SwiftyJSON

extension JSON {
    var date: Date? {
        AutoDateParser.shared.parse(stringValue)
    }
}
