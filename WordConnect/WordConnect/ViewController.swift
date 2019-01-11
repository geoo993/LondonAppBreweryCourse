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
    @IBOutlet weak var congratsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGridTiles(words: ["roma", "made", "red", "dear", "road", "dream", "more"])
    }
    
    func createGridTiles(words: [String]) {
        let wordsUppercased = words.map{ $0.uppercased() }
        grid.delegate = self
        grid.createGrid(words: wordsUppercased, rows: 10, columns: 10, spacing: 2)
        congratsLabel.isHidden = true
    }
    
    func createPanelTiles(wordTiles: [GridTile]) {
        let wordTilesWords = wordTiles.map({ $0.word }).uniqueElements()
        panel.delegate = self
        panel.createWordPanel(with: wordTilesWords)
    }
}

extension ViewController: GridLayoutDelegate {
    
    func gridView(grid: [(rect: CGRect, index: Int)], wordTiles: [GridTile]) {
        
        for (rect, index) in grid {
            if let tile = wordTiles.first(where: { $0.positionInGrid == index }) {
                tile.frame = rect
                tile.text = ""
                tile.textAlignment = .center
                tile.backgroundColor = tile.color
                tile.tag = tile.positionInGrid
                tile.isUserInteractionEnabled = false
                self.grid.addSubview(tile)
            } else {
                let label = UILabel().then {
                    $0.frame = rect
                    $0.text = ""//"\(index)"
                    $0.textAlignment = .center
                    $0.backgroundColor = UIColor.clear
                    $0.tag = index
                    $0.isUserInteractionEnabled = false
                }
                self.grid.addSubview(label)
            }
        }
        
        createPanelTiles(wordTiles: wordTiles)
        
        print(self.grid.subviews.count)
    }
    
    func gridView(found wordTile: [GridTile], completed: Bool) {
        for subview in self.grid.subviews where subview is GridTile {
            if let tile = subview as? GridTile, wordTile.contains(where: { $0.word == tile.word }) {
                tile.backgroundColor = grid.tilesSelectedColor
                tile.text = String(tile.letter).uppercased()
                tile.textColor = grid.tilesTextColor
                tile.textAlignment = .center
            }
        }
        congratsLabel.isHidden = !completed
    }
}

extension ViewController: WordPanelDelegate {
    
    func panelView(tiles: [PanelTile]) {
        let letters = tiles.map({ $0.letter })
        print("Word tiles added", tiles.count, letters)
    }
    
    func panelView(wordFound: String) {
        print("word found: ", wordFound)
        grid.wordFound(word: wordFound, in: self.panel)
    }
}
