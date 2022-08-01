//
//  SceneKitUtils.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/7/31.
//

import SceneKit

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

func += (left: inout SCNVector3, right: SCNVector3) {
    left = left + right
}

func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3Make(vector.x * scalar, vector.y * scalar, vector.z * scalar)
}

infix operator +*
func +* (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
}

func / (left: SCNVector3, right: Float) -> SCNVector3 {
    return SCNVector3Make(left.x / right, left.y / right, left.z / right)
}

func /= (left: inout SCNVector3, right: Float) {
    left = left / right
}

extension SCNVector3 {
    var length: Float {
        sqrtf(x * x + y * y + z * z)
    }
}

extension SCNVector3: CustomStringConvertible {
    public var description: String {
        "SCNVector3: (x: \(x), y: \(y), z: \(z))"
    }
}

/// https://math.stackexchange.com/questions/237369/given-this-transformation-matrix-how-do-i-decompose-it-into-translation-rotati
extension SCNMatrix4 {
    var position: SCNVector3 {
        SCNVector3(m41, m42, m43)
    }

    var scale: SCNVector3 {
        let sx = SCNVector3(x: m11, y: m12, z: m13).length
        let sy = SCNVector3(x: m21, y: m22, z: m23).length
        let sz = SCNVector3(x: m31, y: m32, z: m33).length
        return SCNVector3(sx, sy, sz)
    }
}

extension matrix_float4x4 {
    var position: SCNVector3 {
        SCNMatrix4(self).position
    }

    var scale: SCNVector3 {
        SCNMatrix4(self).scale
    }
}
