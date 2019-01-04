//
//  JourneyExerciseButton.swift
//  StoryView
//
//  Created by GEORGE QUENTIN on 03/01/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

import UIKit
import AppCore

@IBDesignable public final class JourneyExerciseButton: UIView {

    @IBInspectable var cornerRadius: CGFloat = 12 {
        didSet {
            updateButton()
        }
    }
    @IBInspectable var borderWidth: CGFloat = 8 {
        didSet {
            updateButton()
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.darkGreen {
        didSet {
            updateButton()
        }
    }
    
    @IBInspectable var pageImage: UIImage = UIImage() {
        didSet {
            updateButton()
        }
    }
    
    @IBInspectable public var isSelected: Bool = false {
        didSet {
            updateButton()
        }
    }
    @IBInspectable public var isLocked: Bool = false {
        didSet {
            updateButton()
        }
    }
    @IBInspectable var lockedColor: UIColor = UIColor.darkGreen.withAlphaComponent(0.5) {
        didSet {
            updateButton()
        }
    }
    @IBInspectable public var title: String = "Exercise" {
        didSet {
            updateButton()
        }
    }
    @IBInspectable public var titleColor: UIColor = UIColor.darkGreen {
        didSet {
            updateButton()
        }
    }
    @IBInspectable public var titleFontSize: CGFloat = 10 {
        didSet {
            updateButton()
        }
    }
    @IBInspectable public var titleHeightRatio: CGFloat = 0.35 {
        didSet {
            updateButton()
        }
    }
   
    
    // MARK: - View Properties
    var container: UIView!
    public var imageView: UIImageView!
    var titleLabel: UILabel!
   
    // MARK: - View Life Cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createButton()
        updateButton()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createButton()
        updateButton()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        createButton()
        updateButton()
    }
    
    // MARK: - create views
    fileprivate func createButton() {
       
        if titleLabel != nil {
            titleLabel.removeNestedSubviewsAndConstraints()
            titleLabel = nil
        }
        
        if imageView != nil {
            imageView.removeNestedSubviewsAndConstraints()
            imageView = nil
        }
        if container != nil {
            container.removeNestedSubviewsAndConstraints()
            container = nil
        }
        
        subviews.forEach({ $0.removeNestedSubviewsAndConstraints() })
        
        container = UIView()
        addSubview(container)
        
        imageView = UIImageView()
        container.addSubview(self.imageView)
        
        titleLabel = UILabel()
        container.addSubview(self.titleLabel)
        
    }
    
    // MARK: - update views
    fileprivate func updateButton() {
        
        guard let container = self.container,
            let imageView = self.imageView,
            let titleLabel = self.titleLabel else { return }
        
        let shouldSelect = (!isLocked && isSelected)
        let scale = shouldSelect ? -borderWidth : 0
        self.container = container.then {
            $0.frame = CGRect(origin: .zero, size: frame.size).increaseRect(scale, scale)
            $0.backgroundColor = shouldSelect ? borderColor : .white
        }
        
        self.imageView = imageView.then {
            $0.frame = CGRect(origin: .zero, size: container.frame.size)
            $0.contentMode = ContentMode.scaleAspectFill
        }
        
        let titleSize = CGSize(width: container.frame.size.width,
                               height: container.frame.size.height * titleHeightRatio)
        let titleOrigin = CGPoint(x: (container.frame.width - titleSize.width) / 2,
                                  y: (container.frame.height - titleSize.height))
        self.titleLabel = titleLabel.then {
            $0.frame = CGRect(origin: titleOrigin, size: titleSize)
            $0.text = title
            $0.textColor = titleColor
            $0.textAlignment = .center
            $0.font = UIFont(name: FamilyName.quicksandBold, size: titleFontSize)
            $0.backgroundColor = .white
        }
        
        layer.borderColor = shouldSelect ? borderColor.cgColor : UIColor.clear.cgColor
        layer.borderWidth = shouldSelect ? borderWidth : 0
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
    }
}
