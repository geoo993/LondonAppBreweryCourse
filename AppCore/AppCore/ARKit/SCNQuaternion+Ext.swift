//
//  SCNQuaternion+Ext.swift
//  ProjectStemCore
//
//  Created by GEORGE QUENTIN on 15/07/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import SceneKit



// MARK: SCNQuaternion Extensions

// NOTE: Methods below are ordered alphabetically (by base operation name).
//     Decided that this is better than grouping by category because those groupings are somewhat subjective, change with each Swift version (if based on protocols), and this just seemed simpler.  Maybe I'll reorg this in the future though.
extension SCNQuaternion
{
    public static let identity:SCNQuaternion = GLKQuaternionIdentity.toSCN()
    public static let identityFacingVector:SCNVector3 = SCNVector3(0, 0, -1)
    public static let identityUpVector:SCNVector3 = SCNVector3(0, 1, 0)


    public init(from a:SCNVector3, to b:SCNVector3, opposing180Axis:SCNVector3=identityUpVector) {
        let aNormal = a.normalized(), bNormal = b.normalized()
        let dotProduct = aNormal.dotProduct(bNormal)
        if dotProduct >= 1.0 {
            self = GLKQuaternionIdentity.toSCN()
        }
        else if dotProduct < (-1.0 + Float.leastNormalMagnitude) {
            self = GLKQuaternionMakeWithAngleAndVector3Axis(Float.pi, opposing180Axis.toGLK()).toSCN()
        }
        else {
            // from: https://bitbucket.org/sinbad/ogre/src/9db75e3ba05c/OgreMain/include/OgreVector3.h?fileviewer=file-view-default#OgreVector3.h-651
            // looks to be explained at: http://lolengine.net/blog/2013/09/18/beautiful-maths-quaternion-from-vectors
            let s = sqrt((1.0 + dotProduct) * 2.0)
            let xyz = aNormal.crossProduct(bNormal) / s
            self.init(xyz.x, xyz.y, xyz.z, (s * 0.5))
        }
    }


    public init(angle angle_rad:Float, axis axisVector:SCNVector3) {
        self = GLKQuaternionMakeWithAngleAndVector3Axis(angle_rad, axisVector.toGLK()).toSCN()
    }


    // MARK: Angle-Axis

    public func angleAxis() -> (Float, SCNVector3) {
        let self_glk = self.toGLK()
        let angle = GLKQuaternionAngle(self_glk)
        let axis = SCNVector3FromGLKVector3(GLKQuaternionAxis(self_glk))
        return (angle, axis)
    }

    // MARK: Delta

    public func delta(_ other:SCNQuaternion) -> SCNQuaternion {
        return -self * other
    }

    // MARK: Invert

    public static prefix func - (q:SCNQuaternion) -> SCNQuaternion { return q.inverted() }
    public func inverted() -> SCNQuaternion {
        return GLKQuaternionInvert(self.toGLK()).toSCN()
    }
    public mutating func invert() {
        self = self.inverted()
    }

    // MARK: Multiply

    public static func * (a:SCNQuaternion, b:SCNQuaternion) -> SCNQuaternion { return a.multiplied(by: b) }
    public func multiplied(by other:SCNQuaternion) -> SCNQuaternion {
        return GLKQuaternionMultiply(self.toGLK(), other.toGLK()).toSCN()
    }
    public static func *= (q:inout SCNQuaternion, o:SCNQuaternion) { q.multiply(by: o) }
    public mutating func multiply(by other:SCNQuaternion) {
        self = self.multiplied(by: other)
    }

    // MARK: Normalize

    public mutating func normalize() {
        self = GLKQuaternionNormalize(self.toGLK()).toSCN()
    }

    // MARK: Rotate

    public static func * (q:SCNQuaternion, v:SCNVector3) -> SCNVector3 { return q.rotate(vector: v) }
    public func rotate(vector:SCNVector3) -> SCNVector3 {
        return GLKQuaternionRotateVector3(self.toGLK(), vector.toGLK()).toSCN()
    }

    public var q:(Float,Float,Float,Float) {
        return (self.x, self.y, self.z, self.w)
    }
    public init(q:(Float,Float,Float,Float)) {
        self.init(x: q.0, y: q.1, z: q.2, w: q.3)
    }

    public func toGLK() -> GLKQuaternion {
        return GLKQuaternion(q: self.q)
    }
}

extension GLKQuaternion {
    public func toSCN() -> SCNQuaternion {
        return SCNQuaternion(q: self.q)
    }
}

