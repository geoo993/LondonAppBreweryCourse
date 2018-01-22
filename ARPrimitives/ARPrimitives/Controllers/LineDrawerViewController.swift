//
//  LineDrawerViewController.swift
//  ARPrimitives
//
//  Created by GEORGE QUENTIN on 22/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AppCore

public class LineDrawerViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var drawButton: UIButton!
    var previousPoint: SCNVector3?
    var buttonHighlighted = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Drawing Lines"
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self.sceneView.antialiasingMode = .multisampling4X
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARWorldTrackingConfiguration.isSupported {
            let configuration = ARWorldTrackingConfiguration()
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
    
    func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        
        let indices: [Int32] = [0, 1]
        
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        return SCNGeometry(sources: [source], elements: [element])
        
    }
}

// MARK: - ARSCNViewDelegate methods

extension LineDrawerViewController : ARSCNViewDelegate {
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.buttonHighlighted = self.drawButton.isHighlighted
        }
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        guard let pointOfView = sceneView.pointOfView else { return }
        
        let mat = pointOfView.transform
        let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
        let currentPosition = pointOfView.position + (dir * 0.1)
        
        if buttonHighlighted {
            if let previousPoint = previousPoint {
                let color = UIColor.random
                let line = lineFrom(vector: previousPoint, toVector: currentPosition)
                let lineNode = SCNNode(geometry: line)
                lineNode.geometry?.firstMaterial?.diffuse.contents = color
                sceneView.scene.rootNode.addChildNode(lineNode)
                DispatchQueue.main.async { [unowned self] () in
                    self.drawButton.backgroundColor = color
                }
            }
        }
        previousPoint = currentPosition
        //glLineWidth(200)
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
