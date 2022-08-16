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

func * (scalar: Float, vector: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(vector.x * scalar, vector.y * scalar, vector.z * scalar)
}

func * (vector: SCNVector3, scalar: CGFloat) -> SCNVector3 {
    return SCNVector3Make(vector.x * Float(scalar), vector.y * Float(scalar), vector.z * Float(scalar))
}

func * (scalar: CGFloat, vector: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(vector.x * Float(scalar), vector.y * Float(scalar), vector.z * Float(scalar))
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

    var normalized: SCNVector3 {
        self / length
    }
}

extension SCNVector3: CustomStringConvertible {
    public var description: String {
        "SCNVector3: (x: \(x), y: \(y), z: \(z))"
    }
}

/// https://math.stackexchange.com/questions/237369/given-this-transformation-matrix-how-do-i-decompose-it-into-translation-rotati
public extension SCNMatrix4 {
    internal var position: SCNVector3 {
        SCNVector3(m41, m42, m43)
    }

    internal var scale: SCNVector3 {
        let sx = SCNVector3(x: m11, y: m12, z: m13).length
        let sy = SCNVector3(x: m21, y: m22, z: m23).length
        let sz = SCNVector3(x: m31, y: m32, z: m33).length
        return SCNVector3(sx, sy, sz)
    }

    func translated(_ translation: SCNVector3) -> SCNMatrix4 {
        SCNMatrix4Translate(self, translation.x, translation.y, translation.z)
    }

    func translated(x: Float, y: Float, z: Float) -> SCNMatrix4 {
        translated(SCNVector3(x, y, z))
    }

    mutating func translate(_ translation: SCNVector3) {
        self = translated(translation)
    }

    mutating func translate(x: Float, y: Float, z: Float) {
        self = translated(SCNVector3(x, y, z))
    }

    func scaled(_ scale: SCNVector3) -> SCNMatrix4 {
        SCNMatrix4Scale(self, scale.x, scale.y, scale.z)
    }

    func scaled(x: Float, y: Float, z: Float) -> SCNMatrix4 {
        scaled(SCNVector3(x, y, z))
    }

    mutating func scale(_ scale: SCNVector3) {
        self = scaled(scale)
    }

    mutating func scale(x: Float, y: Float, z: Float) {
        self = scaled(SCNVector3(x, y, z))
    }

    func rotated(angle: SCNFloat, axis: SCNVector3) -> SCNMatrix4 {
        SCNMatrix4Rotate(self, angle, axis.x, axis.y, axis.z)
    }

    mutating func rotate(angle: SCNFloat, axis: SCNVector3) {
        self = rotated(angle: angle, axis: axis)
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

extension SCNPlane {
    var size: CGSize {
        CGSize(width: width, height: height)
    }
}
