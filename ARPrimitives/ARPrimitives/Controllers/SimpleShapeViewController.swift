//
//  SimpleShapeViewController.swift
//  arkit-demo
//
//  Created by ttillage on 7/9/17.
//  Copyright © 2017 CapTech. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import AppCore

public class SimpleShapeViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Shapes"
        
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.antialiasingMode = .multisampling4X
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARWorldTrackingConfiguration.isSupported {
            let configuration = ARWorldTrackingConfiguration()
            self.sceneView.session.run(configuration)
        } else if ARConfiguration.isSupported {
            let configuration = AROrientationTrackingConfiguration()
            self.sceneView.session.run(configuration)
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showHelperAlertIfNeeded()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.sceneView.session.pause()
    }
    
    // MARK: - UI Events
    
    @IBAction func tapScreen() {
        if let camera = self.sceneView.pointOfView {
            let sphere = NodeGenerator.generateRandomShapeInFrontOf(node: camera, color: .random)
            self.sceneView.scene.rootNode.addChildNode(sphere)
        }
    }
    
    @IBAction func twoFingerTapScreen() {
        if let camera = self.sceneView.pointOfView {
            let sphere = NodeGenerator.generateCubeInFrontOf(node: camera, physics: false, color: .random)
            self.sceneView.scene.rootNode.addChildNode(sphere)
        }
    }
    
    // MARK: - Private Methods
    
    private func showHelperAlertIfNeeded() {
        let key = "SimpleShapeViewController.helperAlert.didShow"
        if !UserDefaults.standard.bool(forKey: key) {
            let alert = UIAlertController(title: "Shapes", message: "Tap to anchor a random shape to the world. 2-finger tap to anchor a cube into the world.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            UserDefaults.standard.set(true, forKey: key)
        }
    }
}
