//
//  ShapeGenerator.swift
//  arkit-demo
//
//  Created by ttillage on 7/9/17.
//  Copyright © 2017 CapTech. All rights reserved.
//

import Foundation
import SceneKit

struct ShapeGenerator {
    
    static func generateSphereInFrontOf(node: SCNNode, physics: Bool, color: UIColor) -> SCNNode {
        let sphere = SCNSphere(radius: 0.05)
        
        let material = SCNMaterial()
        material.diffuse.contents = color
        sphere.materials = [material]
        
        let sphereNode = SCNNode(geometry: sphere)
        
        let position = SCNVector3(x: 0, y: 0, z: -0.6)
        sphereNode.position = node.convertPosition(position, to: nil)
        
        if physics {
            let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: sphere, options: nil))
            physicsBody.mass = 2.0
            physicsBody.categoryBitMask = CollisionTypes.shape.rawValue
            sphereNode.physicsBody = physicsBody
        }
        
        return sphereNode
    }
}
