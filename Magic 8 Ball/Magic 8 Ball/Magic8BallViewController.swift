//
//  Magic8BallViewController.swift
//  Magic 8 Ball
//
//  Created by GEORGE QUENTIN on 26/12/2017.
//  Copyright © 2017 Geo Games. All rights reserved.
//

import UIKit
import AppCore

class Magic8BallViewController: UIViewController {

    @IBOutlet weak var label : UILabel!
    @IBOutlet weak var imageView : UIImageView!
    @IBAction func askButtonPressed( _ sender : UIButton) {
        rollBall()
    } 
    
    let ballArray = ["ball1","ball2","ball3","ball4","ball5"]
    var randomBallNumber : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rollBall()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        rollBall()
    }

    func rollBall () {
        randomBallNumber = Int.random(min: 0, max: 4)
        imageView.image = UIImage(named: ballArray[randomBallNumber])
    }
}

