//
//  JourneyFinishView.swift
//  StoryView
//
//  Created by GEORGE QUENTIN on 11/05/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

import UIKit

@IBDesignable
class JourneyFinishView: UIView {

    var contentView: JourneyFinishButton?

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }

    // MARK: - Setup
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //view.frame = frame
        contentView = view
        addSubview(view)
    }

    // MARK: - Load
    func loadViewFromNib() -> JourneyFinishButton? {
        return Bundle.main.loadNibNamed("JourneyFinishView", owner: self, options: nil)?[0] as? JourneyFinishButton
    }
}
