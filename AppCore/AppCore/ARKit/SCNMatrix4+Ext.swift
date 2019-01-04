//
//  SCNMatrix4+Ext.swift
//  ProjectStemCore
//
//  Created by GEORGE QUENTIN on 15/07/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import SceneKit

extension SCNMatrix4 : Equatable
{
    public static func == (a:SCNMatrix4, b:SCNMatrix4) -> Bool {
        return SCNMatrix4EqualToMatrix4(a, b)
    }
}

// NOTE: Methods below are ordered alphabetically (by base operation name).
//     Decided that this is better than grouping by category because those groupings are somewhat subjective, change with each Swift version (if based on protocols), and this just seemed simpler.  Maybe I'll reorg this in the future though.
extension SCNMatrix4
{
    public static let identity:SCNMatrix4 = SCNMatrix4Identity

    public func toSimd() -> float4x4 {
        #if swift(>=4.0)
        return float4x4(self)
        #else
        return float4x4(SCNMatrix4ToMat4(self))
        #endif
    }
    public func toGLK() -> GLKMatrix4 {
        return SCNMatrix4ToGLKMatrix4(self)
    }

    public init(_ m:SCNMatrix4) {
        self = m
    }

    public init(translation:SCNVector3) {
        self = SCNMatrix4MakeTranslation(translation.x, translation.y, translation.z)
    }

    public init(rotationAngle angle:Float, axis:SCNVector3) {
        self = SCNMatrix4MakeRotation(angle, axis.x, axis.y, axis.z)
    }

    public init(scale:SCNVector3) {
        self = SCNMatrix4MakeScale(scale.x, scale.y, scale.z)
    }


    // MARK: Invert

    public static prefix func - (m:SCNMatrix4) -> SCNMatrix4 { return m.inverted() }
    public func inverted() -> SCNMatrix4 {
        return SCNMatrix4Invert(self)
    }
    public mutating func invert() {
        self = self.inverted()
    }

    // MARK: Is… Flags

    public var isIdentity:Bool {
        return SCNMatrix4IsIdentity(self)
    }

    // MARK: Multiply

    public static func * (a:SCNMatrix4, b:SCNMatrix4) -> SCNMatrix4 { return a.multiplied(by: b) }
    public func multiplied(by other:SCNMatrix4) -> SCNMatrix4 {
        return SCNMatrix4Mult(self, other)
    }
    public static func *= (m:inout SCNMatrix4, o:SCNMatrix4) { m.multiply(by: o) }
    public mutating func multiply(by other:SCNMatrix4) {
        self = self.multiplied(by: other)
    }

    // MARK: Translate

    public func translated(_ translation:SCNVector3) -> SCNMatrix4 {
        return SCNMatrix4Translate(self, translation.x, translation.y, translation.z)
    }
    public mutating func translate(_ translation:SCNVector3) {
        self = self.translated(translation)
    }

    // MARK: Scale

    public func scaled(_ scale:SCNVector3) -> SCNMatrix4 {
        return SCNMatrix4Scale(self, scale.x, scale.y, scale.z)
    }
    public mutating func scale(_ scale:SCNVector3) {
        self = self.scaled(scale)
    }

    // MARK: Rotate

    public func rotated(angle:Float, axis:SCNVector3) -> SCNMatrix4 {
        return SCNMatrix4Rotate(self, angle, axis.x, axis.y, axis.z)
    }
    public mutating func rotate(angle:Float, axis:SCNVector3) {
        self = self.rotated(angle: angle, axis: axis)
    }
}

extension GLKMatrix4 {
    public func toSCN() -> SCNMatrix4 {
        return SCNMatrix4FromGLKMatrix4(self)
    }
}
