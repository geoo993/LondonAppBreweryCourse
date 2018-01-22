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
    
    static func generateRandomShape(with color: UIColor, at position:SCNVector3, with physics: Bool = false) -> SCNNode {
        let shapeType = ShapeType.random
        var shape = SCNGeometry()
        let radius = CGFloat((0.05...0.1).random())
        
        switch shapeType {
        case .box:
            shape = SCNBox(width: radius, height: radius, length: radius, chamferRadius: 0.01)
        case .sphere:
            shape = SCNSphere(radius: radius)
        case .pyramid:
            shape = SCNPyramid(width: radius, height: radius, length: radius)
        case .torus:
            shape = SCNTorus(ringRadius: radius, pipeRadius: 0.02)
        case .capsule:
            shape = SCNCapsule(capRadius: radius, height: (radius * 2) )
        case .cylinder:
            shape = SCNCylinder(radius: radius, height: (radius * 2))
        case .cone:
            shape = SCNCone(topRadius: radius, bottomRadius: 0.02, height: 0.06)
        case .tube:
            shape = SCNTube(innerRadius: 0.02, outerRadius: 0.05, height: radius)
        }  
        
        let material = SCNMaterial()
        material.diffuse.contents = color
        shape.materials = [material]
        
        let shapeNode = SCNNode(geometry: shape)
        shapeNode.position = position
        
        if physics {
            let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: shape, options: nil))
            physicsBody.mass = 1.25
            physicsBody.restitution = 0.25
            physicsBody.friction = 0.75
            physicsBody.categoryBitMask = CollisionTypes.shape.rawValue
            shapeNode.physicsBody = physicsBody
        }
        
        return shapeNode
    }
    
    static func generateRandomShapeInFrontOf(node: SCNNode, color: UIColor, 
                                             at position:SCNVector3, 
                                             with physics: Bool = false) -> SCNNode {
       
        let shapeNode = generateRandomShape(with: color, at: position, with: physics)
        
        shapeNode.position = node.convertPosition(position, to: nil)
        shapeNode.rotation = node.rotation
        
        return shapeNode
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
