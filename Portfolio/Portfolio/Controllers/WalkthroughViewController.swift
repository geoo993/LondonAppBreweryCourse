//
//  WalkthroughViewController.swift
//  Onboard
//
//  Created by GEORGE QUENTIN on 12/01/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import Lottie

// LOTTIE
// https://www.youtube.com/watch?v=dM6u5FlZB70
// https://www.youtube.com/watch?v=ESjFEaZx7UI
// https://www.youtube.com/watch?v=QyL-jp9bFdM
// https://github.com/airbnb/lottie-ios
// https://github.com/airbnb/lottie-web

class WalkthroughViewController: UIViewController {

    @IBOutlet private var animationView: LOTAnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var loginButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func animation(with animation: String) {
        animationView.setAnimation(named: animation)
        animationView.contentMode = .scaleAspectFill
        animationView.loopAnimation = true
        animationView.play()
    }

}
