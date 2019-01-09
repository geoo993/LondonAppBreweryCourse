//
//  GridView.swift
//  WordConnect
//
//  Created by GEORGE QUENTIN on 09/01/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import AppCore

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
        
    }
    
    func updateLayout() {
        
    }
    
    func createGrid(words: [String], rows: Int, columns: Int, spacing: CGFloat) {
        let grid = Grid(columns: columns, rows: rows, spacing: spacing)
        let wordsearch = GridLayout.createGrid(with: bounds, grid: grid)
        let wordsList = GridLayout.calculateWordsToSearch(with: words, rows: rows, columns: columns)
        let wordTiles = wordsList.flatMap({ (arg) -> [GridTile] in
            let (word, indexes) = arg
            return indexes.enumerated()
                .map({ GridTile(word: word, letter: word[$0], letterIndex: $0, positionInGrid: $1) })
        })
        
        let tiles = wordsearch.frame.compactMap({ rect, index -> UILabel in
            if let tile = wordTiles.first(where: { $0.positionInGrid == index }) {
                return UILabel().then {
                    $0.frame = rect
                    $0.text = String(tile.letter).uppercased()
                    $0.textAlignment = .center
                    $0.backgroundColor = UIColor.yellow
                    $0.tag = tile.positionInGrid
                    $0.isUserInteractionEnabled = false
                }
            } else {
                return UILabel().then {
                    $0.frame = rect
                    $0.text = ""//"\(index)"
                    $0.textAlignment = .center
                    $0.backgroundColor = UIColor.clear
                    $0.tag = index
                    $0.isUserInteractionEnabled = false
                }
            }
        })
        tiles.forEach { addSubview($0) }
    }
}
