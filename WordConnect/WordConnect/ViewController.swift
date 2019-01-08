//
//  ViewController.swift
//  WordConnect
//
//  Created by GEORGE QUENTIN on 08/01/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import AppCore

class ViewController: UIViewController {
    
    @IBOutlet weak var panel: Panel!
    @IBAction func didReduce(_ sender: UIButton) {
        panel.numberOfTiles -= 1
    }
    
    @IBAction func didAdd(_ sender: UIButton) {
        panel.numberOfTiles += 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        panel.delegate = self
        
    }

}

extension ViewController: WordPanelDelegate {
    func wordPanel(tiles: [WordTile]) {
        print("Word tiles added", tiles.count)
    }
    
    func wordPanel(wordFound: String) {
        
    }
    
    
}

