//
//  WordTile.swift
//  WordConnect
//
//  Created by GEORGE QUENTIN on 08/01/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class WordTile: UIButton {
    
    private var state_: UIControl.State = .normal
    public override var state: UIControl.State {
        set {
            state_ = newValue
        }
        
        get {
            return state_
        }
    }
    @IBInspectable var imageTint: UIColor = UIColor.white {
        didSet {
            let tintedImage = imageView?.image?.withRenderingMode(.alwaysTemplate)
            setImage(tintedImage, for: state_)
            tintColor = imageTint
        }
    }
    
    public var index: Int = 0
    public var letter: Character = Character("A") {
        didSet {
            setTitle(String(letter), for: .normal)
        }
    }
    public var textColor: UIColor = UIColor.white {
        didSet {
            setTitleColor(textColor, for: .normal)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
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
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
    }
}


