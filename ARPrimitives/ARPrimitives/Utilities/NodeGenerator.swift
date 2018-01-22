//
//  ShapeGenerator.swift
//  arkit-demo
//
//  Created by ttillage on 7/9/17.
//  Copyright © 2017 CapTech. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import AppCore

struct NodeGenerator {
    
    static func generateRandomShapeInFrontOf(node: SCNNode, color: UIColor) -> SCNNode {
        let shapeNumber = Int.random(min: 1, max: 8)
        var shape = SCNGeometry()
        let radius = (0.02...0.06).random()
        switch shapeNumber {
        case 1:
            shape = SCNCone(topRadius: CGFloat(radius), bottomRadius: 0.01, height: 0.05)
        case 2:
            shape = SCNSphere(radius: CGFloat(radius))
        case 3:
            shape = SCNBox(width: CGFloat(radius), height: CGFloat(radius), length: CGFloat(radius), chamferRadius: 0.01)
        case 4:
            shape = SCNCylinder(radius: CGFloat(radius), height: (CGFloat(radius * 2)))
        case 5:
            shape = SCNCapsule(capRadius: CGFloat(radius), height: (CGFloat(radius * 2)) )
        case 6:
            shape = SCNTorus(ringRadius: CGFloat(radius), pipeRadius: 0.01)
        case 7:
            shape = SCNTube(innerRadius: 0.01, outerRadius: 0.03, height: CGFloat(radius))
        case 8:
            shape = SCNPyramid(width: CGFloat(radius), height: CGFloat(radius), length: CGFloat(radius))
        default:
            print("wrong shape number")
        }
        
        let material = SCNMaterial()
        material.diffuse.contents = color
        shape.materials = [material]
        
        let sphereNode = SCNNode(geometry: shape)
        
        let position = SCNVector3(x: 0, y: 0, z: -1)
        sphereNode.position = node.convertPosition(position, to: nil)
        sphereNode.rotation = node.rotation
        
        return sphereNode
    }
    
    static func generateSphereInFrontOf(node: SCNNode, color: UIColor) -> SCNNode {
        let radius = (0.02...0.06).random()
        let sphere = SCNSphere(radius: CGFloat(radius))

        let material = SCNMaterial()
        material.diffuse.contents = color
        sphere.materials = [material]

        let sphereNode = SCNNode(geometry: sphere)
        
        let position = SCNVector3(x: 0, y: 0, z: -1)
        sphereNode.position = node.convertPosition(position, to: nil)
        sphereNode.rotation = node.rotation
        
        return sphereNode
    }
    
    static func generateCubeInFrontOf(node: SCNNode, physics: Bool, color: UIColor) -> SCNNode {
        let size = CGFloat((0.06...0.1).random())
        let box = SCNBox(width: size, height: size, length: size, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = color
        box.materials = [material]
        
        let boxNode = SCNNode(geometry: box)
        
        let position = SCNVector3(x: 0, y: 0, z: -1)
        boxNode.position = node.convertPosition(position, to: nil)
        boxNode.rotation = node.rotation
        
        if physics {
            let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: box, options: nil))
            physicsBody.mass = 1.25
            physicsBody.restitution = 0.25
            physicsBody.friction = 0.75
            physicsBody.categoryBitMask = CollisionTypes.shape.rawValue
            boxNode.physicsBody = physicsBody
        }
        
        return boxNode
    }
    
    static func generatePlaneFrom(planeAnchor: ARPlaneAnchor, physics: Bool, hidden: Bool) -> SCNNode {
        let plane = self.plane(from: planeAnchor, hidden: hidden)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = self.position(from: planeAnchor)
        
        if physics {
            let body = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: plane, options: nil))
            body.restitution = 0.0
            body.friction = 1.0
            planeNode.physicsBody = body
        }
        
        return planeNode
    }
    
    static func update(planeNode: SCNNode, from planeAnchor: ARPlaneAnchor, hidden: Bool) {
        
        let updatedGeometry = self.plane(from: planeAnchor, hidden: hidden)
        
        planeNode.geometry = updatedGeometry
        planeNode.physicsBody?.physicsShape = SCNPhysicsShape(geometry: updatedGeometry, options: nil)
        planeNode.position = self.position(from: planeAnchor)
    }
    
    static func update(planeNode: SCNNode, hidden: Bool) {
        planeNode.geometry?.materials.first?.diffuse.contents = hidden ? UIColor(white: 1, alpha: 0) : UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
    }
    
    private static func plane(from planeAnchor: ARPlaneAnchor, hidden: Bool) -> SCNGeometry {
        let plane = SCNBox(width: CGFloat(planeAnchor.extent.x), height: 0.005, length: CGFloat(planeAnchor.extent.z), chamferRadius: 0)
        
        let color = SCNMaterial()
        color.diffuse.contents = hidden ? UIColor(white: 1, alpha: 0) : UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
        plane.materials = [color]
        
        return plane
    }
    
    private static func position(from planeAnchor: ARPlaneAnchor) -> SCNVector3 {
        return SCNVector3Make(planeAnchor.center.x, -0.005, planeAnchor.center.z)
    }
    
}

extension ClosedRange where Bound : FloatingPoint {
    public func random() -> Bound {
        let range = self.upperBound - self.lowerBound
        let randomValue = (Bound(arc4random_uniform(UINT32_MAX)) / Bound(UINT32_MAX)) * range + self.lowerBound
        return randomValue
    }
}
