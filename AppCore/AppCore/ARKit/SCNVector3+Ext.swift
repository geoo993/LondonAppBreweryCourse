/*
 * Copyright (c) 2013-2014 Kim Pedersen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import SceneKit

extension SCNVector3 : Equatable
{
    public static func == (a:SCNVector3, b:SCNVector3) -> Bool {
        return SCNVector3EqualToVector3(a, b)
    }
}

extension GLKVector3 {
    public func toSCN() -> SCNVector3 {
        return SCNVector3FromGLKVector3(self)
    }
}

public extension SCNVector3
{
    public static let zero = SCNVector3Zero

    // MARK: Type Conversions
    public func toSimd() -> float3 {
        #if swift(>=4.0)
        return float3(self)
        #else
        return SCNVector3ToFloat3(self)
        #endif
    }
    public func toGLK() -> GLKVector3 {
        return SCNVector3ToGLKVector3(self)
    }


    // MARK: Add

//    public static func + (a:SCNVector3, b:SCNVector3) -> SCNVector3 { return a.added(to: b) }
    public func added(to other:SCNVector3) -> SCNVector3 {
        return (self.toSimd() + other.toSimd()).toSCN()
    }
//    public static func += (v:inout SCNVector3, o:SCNVector3) { v.add(o) }
    public mutating func add(_ other:SCNVector3) {
        self = self.added(to: other)
    }

    // MARK: Cross Product

    public func crossProduct(_ other:SCNVector3) -> SCNVector3 {
        return simd.cross(self.toSimd(), other.toSimd()).toSCN()
    }
    public mutating func formCrossProduct(_ other:SCNVector3) {
        self = self.crossProduct(other)
    }
    public static func crossProductOf(_ a:SCNVector3, _ b:SCNVector3) -> SCNVector3 {
        return a.crossProduct(b)
    }

    // MARK: Divide

//    public static func / (a:SCNVector3, b:SCNVector3) -> SCNVector3 { return a.divided(by: b) }
    public func divided(by other:SCNVector3) -> SCNVector3 {
        return (self.toSimd() / other.toSimd()).toSCN()
    }
//    public static func / (a:SCNVector3, b:Float) -> SCNVector3 { return a.divided(by: b) }
    public func divided(by scalar:Float) -> SCNVector3 {
        return (self.toSimd() * recip(scalar)).toSCN()
    }
//    public static func /= (v:inout SCNVector3, o:SCNVector3) { v.divide(by: o) }
    public mutating func divide(by other:SCNVector3) {
        self = self.divided(by: other)
    }
//    public static func /= (v:inout SCNVector3, o:Float) { v.divide(by: o) }
    public mutating func divide(by scalar:Float) {
        self = self.divided(by: scalar)
    }

    // MARK: Dot Product

    public func dotProduct(_ other:SCNVector3) -> Float {
        return simd.dot(self.toSimd(), other.toSimd())
    }
    public static func dotProductOf(_ a:SCNVector3, _ b:SCNVector3) -> Float {
        return a.dotProduct(b)
    }

    // MARK: Is… Flags

    public var isFinite:Bool {
        return self.x.isFinite && self.y.isFinite && self.z.isFinite
    }
    public var isInfinite:Bool {
        return self.x.isInfinite || self.y.isInfinite || self.z.isInfinite
    }
    public var isNaN:Bool {
        return self.x.isNaN || self.y.isNaN || self.z.isNaN
    }
    public var isZero:Bool {
        return self.x.isZero && self.y.isZero && self.z.isZero
    }

    // MARK: Magnitude

    public func magnitude() -> Float {
        return simd.length(self.toSimd())
    }
    public func magnitudeSquared() -> Float {
        return simd.length_squared(self.toSimd())
    }

    // MARK: Mix

    public func mixed(with other:SCNVector3, ratio:Float) -> SCNVector3 {
        return simd.mix(self.toSimd(), other.toSimd(), t: ratio).toSCN()
    }
    public mutating func mix(with other:SCNVector3, ratio:Float) {
        self = self.mixed(with: other, ratio: ratio)
    }
    public static func mixOf(_ a:SCNVector3, _ b:SCNVector3, ratio:Float) -> SCNVector3 {
        return a.mixed(with: b, ratio: ratio)
    }

    // MARK: Multiply

//    public static func * (a:SCNVector3, b:SCNVector3) -> SCNVector3 { return a.multiplied(by: b) }
    public func multiplied(by other:SCNVector3) -> SCNVector3 {
        return (self.toSimd() * other.toSimd()).toSCN()
    }
//    public static func * (a:SCNVector3, b:Float) -> SCNVector3 { return a.multiplied(by: b) }
    public func multiplied(by scalar:Float) -> SCNVector3 {
        return (self.toSimd() * scalar).toSCN()
    }
//    public static func *= (v:inout SCNVector3, o:SCNVector3) { v.multiply(by: o) }
    public mutating func multiply(by other:SCNVector3) {
        self = self.multiplied(by: other)
    }
//    public static func *= (v:inout SCNVector3, o:Float) { v.multiply(by: o) }
    public mutating func multiply(by scalar:Float) {
        self = self.multiplied(by: scalar)
    }

    // MARK: Invert

    public static prefix func - (v:SCNVector3) -> SCNVector3 { return v.inverted() }
    public func inverted() -> SCNVector3 {
        return (float3(0) - self.toSimd()).toSCN()
    }
    public mutating func invert() {
        self = self.inverted()
    }


    // MARK: Project

    public func projected(onto other:SCNVector3) -> SCNVector3 {
        return simd.project(self.toSimd(), other.toSimd()).toSCN()
    }
    public mutating func project(onto other:SCNVector3) {
        self = self.projected(onto: other)
    }

    // MARK: Reflect

    public func reflected(normal:SCNVector3) -> SCNVector3 {
        return simd.reflect(self.toSimd(), n: normal.toSimd()).toSCN()
    }
    public mutating func reflect(normal:SCNVector3) {
        self = self.reflected(normal: normal)
    }

    // MARK: Refract

    public func refracted(normal:SCNVector3, refractiveIndex:Float) -> SCNVector3 {
        return simd.refract(self.toSimd(), n: normal.toSimd(), eta: refractiveIndex).toSCN()
    }
    public mutating func refract(normal:SCNVector3, refractiveIndex:Float) {
        self = self.refracted(normal: normal, refractiveIndex: refractiveIndex)
    }

    // MARK: Replace

    public mutating func replace(x:Float?=nil, y:Float?=nil, z:Float?=nil) {
        if let xValue = x { self.x = xValue }
        if let yValue = y { self.y = yValue }
        if let zValue = z { self.z = zValue }
    }
    public func replacing(x:Float?=nil, y:Float?=nil, z:Float?=nil) -> SCNVector3 {
        return SCNVector3(
            x ?? self.x,
            y ?? self.y,
            z ?? self.z
        )
    }

    // MARK: Subtract

//    public static func - (a:SCNVector3, b:SCNVector3) -> SCNVector3 { return a.subtracted(by: b) }
    public func subtracted(by other:SCNVector3) -> SCNVector3 {
        return (self.toSimd() - other.toSimd()).toSCN()
    }
//    public static func -= (v:inout SCNVector3, o:SCNVector3) { v.subtract(o) }
    public mutating func subtract(_ other:SCNVector3) {
        self = self.subtracted(by: other)
    }

    /**
     * Negates the vector described by SCNVector3 and returns
     * the result as a new SCNVector3.
     */
    public func negate() -> SCNVector3 {
        return self * -1
    }
    
    /**
     * Negates the vector described by SCNVector3
     */
    public mutating func negated() -> SCNVector3 {
        self = negate()
        return self
    }
    
    /**
     * Returns the length (magnitude) of the vector described by the SCNVector3
     */
    public func length() -> Float {
        return sqrtf(x*x + y*y + z*z)
    }
    
    /**
     * Normalizes the vector described by the SCNVector3 to length 1.0 and returns
     * the result as a new SCNVector3.
     */
    public func normalized() -> SCNVector3 {
        return self / length()
    }
//    public func normalized() -> SCNVector3 {
//        return simd.normalize(self.toSimd()).toSCN()
//    }

    /**
     * Normalizes the vector described by the SCNVector3 to length 1.0.
     */
    public mutating func normalize() -> SCNVector3 {
        self = normalized()
        return self
    }
    
    /**
     * Calculates the distance between two SCNVector3. Pythagoras!
     */
    public func distance(vector: SCNVector3) -> Float {
        return (self - vector).length()
    }
    
    /**
     * Calculates the dot product between two SCNVector3.
     */
    public func dot(vector: SCNVector3) -> Float {
        return x * vector.x + y * vector.y + z * vector.z
    }
    
    /**
     * Calculates the cross product between two SCNVector3.
     */
    public func cross(vector: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(y * vector.z - z * vector.y, z * vector.x - x * vector.z, x * vector.y - y * vector.x)
    }
    
    public static func pointInFrontOfPoint(point: SCNVector3, direction: SCNVector3, distance: Float) -> SCNVector3 {
        var x = Float()
        var y = Float()
        var z = Float()
        
        x = point.x + distance * direction.x
        y = point.y + distance * direction.y
        z = point.z + distance * direction.z
        
        let result = SCNVector3Make(x, y, z)
        return result
    }
    
    public static func calculateCameraDirection(cameraNode: SCNNode) -> SCNVector3 {
        let x = -cameraNode.rotation.x
        let y = -cameraNode.rotation.y
        let z = -cameraNode.rotation.z
        let w = cameraNode.rotation.w
        let cameraRotationMatrix = GLKMatrix3Make(cos(w) + pow(x, 2) * (1 - cos(w)),
                                                  x * y * (1 - cos(w)) - z * sin(w),
                                                  x * z * (1 - cos(w)) + y*sin(w),
                                                  
                                                  y*x*(1-cos(w)) + z*sin(w),
                                                  cos(w) + pow(y, 2) * (1 - cos(w)),
                                                  y*z*(1-cos(w)) - x*sin(w),
                                                  
                                                  z*x*(1 - cos(w)) - y*sin(w),
                                                  z*y*(1 - cos(w)) + x*sin(w),
                                                  cos(w) + pow(z, 2) * ( 1 - cos(w)))
        
        let cameraDirection = GLKMatrix3MultiplyVector3(cameraRotationMatrix, GLKVector3Make(0.0, 0.0, -1.0))
        return SCNVector3FromGLKVector3(cameraDirection)
    }
}

/**
 * Adds two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
public func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

/**
 * Increments a SCNVector3 with the value of another.
 */
public func += (left: inout SCNVector3, right: SCNVector3) {
    left = left + right
}

/**
 * Subtracts two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
public func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

/**
 * Decrements a SCNVector3 with the value of another.
 */
public func -= (left: inout  SCNVector3, right: SCNVector3) {
    left = left - right
}

/**
 * Multiplies two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
public func * (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
}

/**
 * Multiplies a SCNVector3 with another.
 */
public func *= (left: inout  SCNVector3, right: SCNVector3) {
    left = left * right
}

/**
 * Multiplies the x, y and z fields of a SCNVector3 with the same scalar value and
 * returns the result as a new SCNVector3.
 */
public func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3Make(vector.x * scalar, vector.y * scalar, vector.z * scalar)
}

/**
 * Multiplies the x and y fields of a SCNVector3 with the same scalar value.
 */
public func *= (vector: inout  SCNVector3, scalar: Float) {
    vector = vector * scalar
}

/**
 * Divides two SCNVector3 vectors abd returns the result as a new SCNVector3
 */
public func / (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
}

/**
 * Divides a SCNVector3 by another.
 */
public func /= (left: inout  SCNVector3, right: SCNVector3) {
    left = left / right
}

/**
 * Divides the x, y and z fields of a SCNVector3 by the same scalar value and
 * returns the result as a new SCNVector3.
 */
public func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3Make(vector.x / scalar, vector.y / scalar, vector.z / scalar)
}

/**
 * Divides the x, y and z of a SCNVector3 by the same scalar value.
 */
public func /= (vector: inout  SCNVector3, scalar: Float) {
    vector = vector / scalar
}

/**
 * Negate a vector
 */
public func SCNVector3Negate(vector: SCNVector3) -> SCNVector3 {
    return vector * -1
}

/**
 * Returns the length (magnitude) of the vector described by the SCNVector3
 */
public func SCNVector3Length(_ vector: SCNVector3) -> Float
{
    return sqrtf(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z)
}

/**
 * Returns the distance between two SCNVector3 vectors
 */
public func SCNVector3Distance(vectorStart: SCNVector3, vectorEnd: SCNVector3) -> Float {
    return SCNVector3Length(vectorEnd - vectorStart)
}

/**
 * Returns the distance between two SCNVector3 vectors
 */
public func SCNVector3Normalize(vector: SCNVector3) -> SCNVector3 {
    return vector / SCNVector3Length(vector)
}

/**
 * Calculates the dot product between two SCNVector3 vectors
 */
public func SCNVector3DotProduct(_ left: SCNVector3, right: SCNVector3) -> Float {
    return left.x * right.x + left.y * right.y + left.z * right.z
}

/**
 * Calculates the cross product between two SCNVector3 vectors
 */
public func SCNVector3CrossProduct(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.y * right.z - left.z * right.y, left.z * right.x - left.x * right.z, left.x * right.y - left.y * right.x)
}

/**
 * Calculates the SCNVector from lerping between two SCNVector3 vectors
 */
public func SCNVector3Lerp(vectorStart: SCNVector3, vectorEnd: SCNVector3, t: Float) -> SCNVector3 {
    return SCNVector3Make(vectorStart.x + ((vectorEnd.x - vectorStart.x) * t), vectorStart.y + ((vectorEnd.y - vectorStart.y) * t), vectorStart.z + ((vectorEnd.z - vectorStart.z) * t))
}

/**
 * Project the vector, vectorToProject, onto the vector, projectionVector.
 */
public func SCNVector3Project(vectorToProject: SCNVector3, projectionVector: SCNVector3) -> SCNVector3 {
    let scale: Float = SCNVector3DotProduct(projectionVector, right: vectorToProject) / SCNVector3DotProduct(projectionVector, right: projectionVector)
    let v: SCNVector3 = projectionVector * scale
    return v
}


