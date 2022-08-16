//
//  ChartProxy+PositionWithJSON.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/16.
//

import Foundation
import Charts
import SwiftyJSON

extension ChartProxy {
    func position(at valuePoint: (x: JSON, y: JSON)) -> CGPoint? {
        if let xPoint = position(atX: valuePoint.x),
           let yPoint = position(atY: valuePoint.y) {
            return CGPoint(x: xPoint, y: yPoint)
        }
        return nil
    }

    func position(atX x: JSON) -> CGFloat? {
        if let intValue = x.int {
            return position(forX: intValue)
        } else if let doubleValue = x.double {
            return position(forX: doubleValue)
        } else if let dateValue = x.date {
            return position(forX: dateValue)
        } else if let stringValue = x.string {
            return position(forX: stringValue)
        }
        return nil
    }

    func position(atY y: JSON) -> CGFloat? {
        if let intValue = y.int {
            return position(forY: intValue)
        } else if let doubleValue = y.double {
            return position(forY: doubleValue)
        } else if let dateValue = y.date {
            return position(forY: dateValue)
        } else if let stringValue = y.string {
            return position(forY: stringValue)
        }
        return nil
    }
}
