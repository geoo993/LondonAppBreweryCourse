//
//  GridTile.swift
//  WordConnect
//
//  Created by GEORGE QUENTIN on 09/01/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
public class GridTile: UILabel {
    
    let word: String
    let letter: Character
    let letterIndex: Int
    let positionInGrid: Int
    let color: UIColor
    
    public init(frame: CGRect,
                word: String,
                letter: Character,
                letterIndex: Int,
                positionInGrid: Int,
                color: UIColor) {
        self.word = word
        self.letter = letter
        self.letterIndex = letterIndex
        self.positionInGrid = positionInGrid
        self.color = color
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.word = ""
        self.letter = "A"
        self.letterIndex = 0
        self.positionInGrid = 0
        self.color = .white
        super.init(coder: aDecoder)
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
}


