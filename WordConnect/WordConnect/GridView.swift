//
//  GridView.swift
//  WordConnect
//
//  Created by GEORGE QUENTIN on 09/01/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import AppCore

//Write the protocol declaration here:
protocol GridLayoutDelegate {
    func gridView(grid: [(rect: CGRect, index: Int)], wordTiles: [GridTile])
    func gridView(found wordTile: [GridTile], completed: Bool)
}

@IBDesignable
public final class GridView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    public var tilesColor: UIColor = UIColor.red {
        didSet {
            updateLayout()
        }
    }
    
    @IBInspectable
    public var tilesTextColor: UIColor = UIColor.white {
        didSet {
            updateLayout()
        }
    }
    
    @IBInspectable
    public var tilesSelectedColor: UIColor = UIColor.green {
        didSet {
            updateLayout()
        }
    }
    
    var delegate : GridLayoutDelegate?
    private var wordTiles: [GridTile] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialLayout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialLayout()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initialLayout()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func initialLayout() {
        removeSubviewsAndConstraints()
        wordTiles = []
    }
    
    func updateLayout() {
        
    }
    
    func createGrid(words: [String], rows: Int, columns: Int, spacing: CGFloat) {
        let grid = Grid(columns: columns, rows: rows, spacing: spacing)
        let wordsearch = GridLayout.createGrid(with: bounds, grid: grid)
        let wordsList = GridLayout.calculateWordsToSearch(with: words, rows: rows, columns: columns)
        self.wordTiles = wordsList.flatMap({ (arg) -> [GridTile] in
            let (word, indexes) = arg
            let color = UIColor.random
            return indexes.enumerated()
                .map({ GridTile(frame: CGRect.zero,
                                word: word,
                                letter: word[$0],
                                letterIndex: $0,
                                positionInGrid: $1,
                                color: color) })
        })
        
        if let delegate = self.delegate {
            delegate.gridView(grid: wordsearch.frame, wordTiles: wordTiles)
        }
    }
    
    func wordFound(word: String, in panel: PanelView) {
        let tilesFound = wordTiles.filter({ $0.word == word })
        if let delegate = self.delegate {
            panel.ignore(word: word)
            delegate.gridView(found: tilesFound, completed: panel.isWordsFound)
        }
    }
}
