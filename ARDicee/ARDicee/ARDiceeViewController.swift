//
//  ARDiceeViewController.swift
//  ARDicee
//
//  Created by GEORGE QUENTIN on 21/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AppCore

public class ARDiceeViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var dices = [SCNNode]()
    
    @IBAction func rollDices(_ sender : UIBarButtonItem) {
        rollAll()
    }
    
    @IBAction func removeDices(_ sender : UIBarButtonItem) {
        removeAll()
    }
   
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
        setup()
        
        /*
        // create geometry with measurement in meters
        //let geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.02)
        let geometry = SCNSphere(radius: 0.4)
        
        let colorMaterial = SCNMaterial()
        colorMaterial.diffuse.contents =  UIColor.cyan
        
        let diceTextureMaterial = SCNMaterial()
        diceTextureMaterial.diffuse.contents =  UIImage(named:"art.scnassets/white6.jpg")
        
        let sunTextureMaterial = SCNMaterial()
        sunTextureMaterial.diffuse.contents =  UIImage(named:"art.scnassets/sun.jpg")
        
        geometry.materials = [sunTextureMaterial]
        
        // create node for objects
        let node = SCNNode()
        node.position = SCNVector3(x: 0.0, y:0.4, z: -1.0)
        node.geometry = geometry
        
        // add cube in scene
        sceneView.scene.rootNode.addChildNode(node)
        */
        
    }
    
    
    func setup() {
        // Set the view's delegate
        sceneView.delegate = self
        
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Enable lighting
        sceneView.autoenablesDefaultLighting = true
    }
    
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("AR Configuration supported:", ARConfiguration.isSupported)
        print("AR World Tracking Configuration Supported:",ARWorldTrackingConfiguration.isSupported)
        
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
    
    // MARK - Dice methods
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
    
    func addDice(at position: simd_float4) {
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/dice.scn")!
        
        if let diceNode = scene.rootNode.childNode(withName: "Dice", recursively: true) {
            diceNode.position = SCNVector3(x: position.x, 
                                           y: position.y + diceNode.boundingSphere.radius, 
                                           z: position.z)
            dices.append(diceNode)
            sceneView.scene.rootNode.addChildNode(diceNode)
            
            roll(dice: diceNode)
        }
    }
    
    func roll(dice: SCNNode) {
        if dices.contains(dice) {
            let randomX = CGFloat.random(min: -180, max: 180) * 5
            let randomZ = CGFloat.random(min: -180, max: 180) * 5
            dice.runAction(SCNAction
                .rotateBy(x: randomX.toRadians, 
                          y: 0, 
                          z: randomZ.toRadians, 
                          duration: 0.5))
        }
    }
    
    func rollAll() {
        
        if dices.isEmpty {
            return
        }
        
        for dice in dices {
            roll(dice: dice)
        }
    }
    
    func removeAll() {
        
        if dices.isEmpty {
            return
        }
        
        for dice in dices {
            dice.removeFromParentNode()
        }
        dices.removeAll()
    }
}

// MARK: - ARSCNViewDelegate methods

extension ARDiceeViewController {   
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
            
            //print("plane detected", planeAnchor)
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
extension ARDiceeViewController {  

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
                addDice(at: hitResult.worldTransform.columns.3)
            }
        }
    }
    
}

// MARK: - Shake Motion 
extension ARDiceeViewController {  
    
    public override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        rollAll()
    }
}
