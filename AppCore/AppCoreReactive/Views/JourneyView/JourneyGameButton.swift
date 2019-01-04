//
//  JourneyGameButton.swift
//  StoryView
//
//  Created by GEORGE QUENTIN on 08/01/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

import UIKit
import AppCore

@IBDesignable
public final class JourneyGameButton: UIView {

    @IBInspectable var cornerRadiusRounded: Bool = true {
        didSet {
            
            updateButton()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            updateButton()
        }
    }

    @IBInspectable var borderWidth: CGFloat = 6 {
        didSet {
            updateButton()
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.darkGreen {
        didSet {
            updateButton()
        }
    }

    @IBInspectable var gameImage: UIImage = UIImage() {
        didSet {
            updateButton()
        }
    }

    @IBInspectable var isSelected: Bool = false {
        didSet {
            updateButton()
        }
    }

    @IBInspectable var isLocked: Bool = false {
        didSet {
            updateButton()
        }
    }

    @IBInspectable var lockedColor: UIColor = UIColor.darkGreen.withAlphaComponent(0.5) {
        didSet {
            updateButton()
        }
    }

    @IBInspectable var title: String = "Game" {
        didSet {
            updateButton()
        }
    }

    @IBInspectable var titleColor: UIColor = UIColor.white {
        didSet {
            updateButton()
        }
    }

    @IBInspectable var titleFontSize: CGFloat = 10 {
        didSet {
            updateButton()
        }
    }

    @IBInspectable var titleHeightRatio: CGFloat = 0.35 {
        didSet {
            updateButton()
        }
    }

    // MARK: - View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateButton()
    }

    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateButton()
    }

    // MARK: - update view
    fileprivate func updateButton() {

        subviews.forEach({ $0.removeNestedSubviewsAndConstraints() })

        let shouldSelect = (!isLocked && isSelected)
        let scale = shouldSelect ? -borderWidth : 0
        let container = UIView().then {
            $0.frame = CGRect(origin: .zero, size: frame.size).increaseRect(scale, scale)
            $0.backgroundColor = shouldSelect ? borderColor : self.backgroundColor
        }
        addSubview(container)

        let imageView = UIImageView().then {
            $0.frame = CGRect(origin: .zero, size: container.frame.size)
            $0.image = gameImage
        }
        container.addSubview(imageView)

        let titleSize = CGSize(width: container.frame.size.width,
                               height: container.frame.size.height * titleHeightRatio)
        let titleOrigin = CGPoint(x: (container.frame.width - titleSize.width) / 2,
                                  y: (container.frame.height - titleSize.height))
        let titleLabel = UILabel().then {
            $0.frame = CGRect(origin: titleOrigin, size: titleSize)
            $0.text = title
            $0.textColor = titleColor
            $0.textAlignment = .center
            $0.font = UIFont(name: FamilyName.quicksandBold, size: titleFontSize)
            $0.backgroundColor = UIColor.clear
        }
        container.addSubview(titleLabel)

        layer.borderColor = shouldSelect ? borderColor.cgColor : UIColor.clear.cgColor
        layer.borderWidth = shouldSelect ? borderWidth : 0
        let cornerRadiusValue = cornerRadiusRounded ? (frame.width * 0.5) : cornerRadius
        layer.cornerRadius = cornerRadiusValue
        layer.masksToBounds = cornerRadiusValue > 0
    }

}
