//
//  TossShapeViewController.swift
//  ARPrimitives
//
//  Created by GEORGE QUENTIN on 22/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//
// https://www.raywenderlich.com/146176/scene-kit-tutorial-swift-part-2-nodes-2
// https://www.raywenderlich.com/146178/scene-kit-tutorial-swift-part-4-render-loop-2

import UIKit
import ARKit
import SceneKit
import AppCore

public class TossShapeViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    var cameraNode: SCNNode!
    var verticalBoundary : Float = -10 
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Toss Shapes"
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.antialiasingMode = .multisampling4X
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        //sceneView.showsStatistics = true
        
        //sceneView.allowsCameraControl = true
        
        sceneView.autoenablesDefaultLighting = true
        
        sceneView.isPlaying = true
    }
    
    func spawnShape(at testResult: ARHitTestResult) {
        
        if let camera = self.sceneView.pointOfView {
            let worldPosition = testResult.worldTransform.columns.3
            let testResultPosition = SCNVector3(x: worldPosition.x, y: worldPosition.y, z: worldPosition.z)
            let geometryNode = NodeGenerator
                .generateRandomShape(with: .random,
                                     at: testResultPosition, 
                                     with: true)
            let dir = SCNVector3.calculateCameraDirection(cameraNode: camera)
            applyForce(to: geometryNode, inDirection: dir)
            sceneView.scene.rootNode.addChildNode(geometryNode)
        }
    }
    
    func spawnShape() {
        if let camera = self.sceneView.pointOfView {
            
            let dir = SCNVector3.calculateCameraDirection(cameraNode: camera)
            let pos = SCNVector3.pointInFrontOfPoint(point: camera.position, direction:dir, distance: 1.8)
            
            let geometryNode = NodeGenerator
                .generateRandomShapeInFrontOf(node: camera, 
                                              color: .random, 
                                              at: SCNVector3(x: 0, y: -0.03, z: -1),
                                              with: true)
            
            geometryNode.position = pos
            geometryNode.orientation = camera.orientation
            applyForce(to: geometryNode, inDirection: dir)
            self.sceneView.scene.rootNode.addChildNode(geometryNode)
        }
    }
    
    func applyForce(to node: SCNNode, inDirection: SCNVector3) {
        
        //let randomX = Float.random(min: -0.15, max: 0.15)
        let randomY = Float.random(min: 0.5, max: 4.0)
        //let randomZ = Float.random(min: -2.5, max: 0.0)
        //let force = SCNVector3(x: randomX, y: randomY , z: randomZ)
        
        var direction = inDirection
        direction = direction.normalize() * 5.0
        let force = SCNVector3(x: direction.x, y: direction.y + randomY , z: direction.z)
        
        let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
        
        node.physicsBody?.applyForce(force, at: position, asImpulse: true)
    }
    
    func setupCamera() {
        // 1
        cameraNode = SCNNode()
        // 2
        cameraNode.camera = SCNCamera()
        // 3
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        // 4
        sceneView.scene.rootNode.addChildNode(cameraNode)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARWorldTrackingConfiguration.isSupported {
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal
            sceneView.session.run(configuration)
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showHelperAlertIfNeeded()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    private func showHelperAlertIfNeeded() {
        let key = "PlaneMapperViewController.helperAlert.didShow"
        if !UserDefaults.standard.bool(forKey: key) {
            let alert = UIAlertController(title: "Drawing Lines", message: "Hold the button and move around to draw line into the world.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            UserDefaults.standard.set(true, forKey: key)
        }
    }
}

// MARK: - ARSCNViewDelegate methods

extension TossShapeViewController : ARSCNViewDelegate {
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        for node in sceneView.scene.rootNode.childNodes {
            if node.presentation.position.y < verticalBoundary {
                node.removeFromParentNode()
            }
        }
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
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
extension TossShapeViewController {  
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: [.existingPlaneUsingExtent])
            
            if let hitResult = results.first {
                spawnShape(at: hitResult)
            }else {                
                spawnShape()
            }
        }
        
    }
}

