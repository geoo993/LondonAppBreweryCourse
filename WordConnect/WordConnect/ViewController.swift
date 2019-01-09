//
//  ViewController.swift
//  WordConnect
//
//  Created by GEORGE QUENTIN on 08/01/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var grid: GridView!
    @IBOutlet weak var panel: PanelView!
    
    var words: [String] = ["roma", "made", "red", "dear", "road", "dream", "more"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        grid.createGrid(words: words, rows: 10, columns: 10, spacing: 2)
        
        panel.delegate = self
        panel.createWordPanel(with: words)
        
    }
}

extension ViewController: WordPanelDelegate {
    func panelView(tiles: [WordTile]) {
        let letters = tiles.map({ $0.letter })
        print("Word tiles added", tiles.count, letters)
    }
    
    func panelView(wordFound: String) {
        print("word found: ", wordFound)
        panel.wordsToIgnore.append(wordFound)
    }
}

