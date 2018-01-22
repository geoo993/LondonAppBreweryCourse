//
//  ARRulerViewController.swift
//  ARRuler
//
//  Created by GEORGE QUENTIN on 22/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AppCore

public class ARRulerViewController: UIViewController, ARSCNViewDelegate {

    var dots = [SCNNode]()
    var textNode = SCNNode()
    var lineNode = SCNNode()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        /*
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
         */
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func setup() {
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Enable lighting
        sceneView.autoenablesDefaultLighting = true
    }
    
    // MARK - objects 
    func createSun () {
        
        // create geometry with measurement in meters
        //let geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.02)
        let geometry = SCNSphere(radius: 0.4)
        
        let sunTextureMaterial = SCNMaterial()
        sunTextureMaterial.diffuse.contents =  UIImage(named:"art.scnassets/sun.jpg")
        
        geometry.materials = [sunTextureMaterial]
        
        // create node for objects
        let node = SCNNode()
        node.position = SCNVector3(x: 0.0, y:0.4, z: -1.0)
        node.geometry = geometry
        
        // add cube in scene
        sceneView.scene.rootNode.addChildNode(node)
        
    }
    
    func createPlane(withPlaneAnchor planeAnchor : ARPlaneAnchor) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents =  UIImage(named:"art.scnassets/grid.png")
        
        plane.materials = [gridMaterial]
        
        let planeNode = SCNNode()
        let angle : Float = 90
        planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
        planeNode.transform = SCNMatrix4Rotate(planeNode.transform, -angle.toRadians , 1, 0, 0)
        planeNode.geometry = plane
        
        return planeNode
    }

    func addDot(at location: ARHitTestResult) {
        let position = location.worldTransform.columns.3
        let dot = SCNSphere(radius: 0.01)
        
        let dotMaterial = SCNMaterial()
        dotMaterial.diffuse.contents =  UIColor.random
        dot.materials = [dotMaterial]
        
        // create node for objects
        let node = SCNNode(geometry: dot)
        node.position = SCNVector3(x: position.x, 
                                   y: position.y, 
                                   z: position.z)
        
        // add cube in scene
        sceneView.scene.rootNode.addChildNode(node)
        
        dots.append(node)
        
        calculateDistance()
    }
    
    func removeDots() {
        
        if dots.isEmpty {
            return
        }
        
        for dot in dots {
            dot.removeFromParentNode()
        }
        
        dots.removeAll()
        textNode.removeFromParentNode()
        lineNode.removeFromParentNode()
    }
    
    func calculateDistance() {
        if dots.isEmpty || dots.count < 2 {
            return 
        }
        
        if let firstDot = dots.first, let lastDot = dots.last {
            let dist = distance(between: firstDot.position, lastDot.position)
            let mid = midPosition(between: firstDot.position, lastDot.position)
            let color = UIColor.random
            renderText(with: dist, at: mid, with: color)
            //renderLine(from: firstDot.position, to: lastDot.position, with: .white, at: mid)
        }
    }
    
    func renderText(with distance: Float, at position: SCNVector3, with color: UIColor) {
        let textGeometry = SCNText(string: "\(distance)", extrusionDepth: 0.5) 
        
        textNode = SCNNode(geometry: textGeometry)
        textNode.geometry?.firstMaterial?.diffuse.contents = color
        textNode.position = position
        
        textNode.scale = SCNVector3Make(0.005, 0.005, 0.005)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    func renderLine(from start: SCNVector3, to end: SCNVector3, with color: UIColor, at position: SCNVector3) {
        let line = lineGeometry(from: start, to: end)
        
        lineNode = SCNNode(geometry: line)
        lineNode.geometry?.firstMaterial?.diffuse.contents = color
        lineNode.position = position
        lineNode.scale = SCNVector3Make(10, 1, 1)
        sceneView.scene.rootNode.addChildNode(lineNode)
        
        glLineWidth(100)
    }
}


// MARK: - ARSCNViewDelegate methods

extension ARRulerViewController {   
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if let planeAnchor = anchor as? ARPlaneAnchor {
            let planeNode = createPlane(withPlaneAnchor: planeAnchor)
            node.addChildNode(planeNode)
        } else { 
            return
        }
    }
    
    public func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    public func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    public func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}


// MARK: - Touches in view
extension ARRulerViewController {  
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = results.first {
                if (dots.count >= 2) {
                    removeDots()
                }
                addDot(at: hitResult)
            }
        }
    }
}

// MARK: - Helper Methods
extension ARRulerViewController {  


    func distance(between start: SCNVector3, _ end: SCNVector3) -> Float {
        let dx : Float = end.x - start.x
        let dy : Float = end.y - start.y
        let dz : Float = end.z - start.z
        return sqrt( ( pow(dx, 2) + pow(dy, 2) + pow(dz, 2) ) )
    }
    
    func midPosition(between start: SCNVector3, _ end: SCNVector3) -> SCNVector3 {
        let x : Float = (start.x + end.x) / 2
        let y : Float = (start.y + end.y) / 2
        let z : Float = (start.z + end.z) / 2
        return SCNVector3(x:x, y:y, z:z)
    }
    
    func lineGeometry(from start: SCNVector3, to end: SCNVector3) -> SCNGeometry {
        
        let indices: [Int32] = [0, 1]
        
        let source = SCNGeometrySource(vertices: [start, end])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        return SCNGeometry(sources: [source], elements: [element])
    }
    
}
