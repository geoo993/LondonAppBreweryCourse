//
//  DiceeViewController.swift
//  Dicee
//
//  Created by GEORGE QUENTIN on 25/12/2017.
//  Copyright © 2017 Geo Games. All rights reserved.
//

import UIKit
import AppCore

class DiceeViewController: UIViewController {

    var randomDiceIndex1  : Int = 0
    var randomDiceIndex2  : Int = 0
    
    @IBOutlet weak var dice1ImageView : UIImageView!
    @IBOutlet weak var dice2ImageView : UIImageView!
    @IBOutlet weak var bingoText : UILabel!
    @IBAction func rollButtonPressed ( _ sender : UIButton) {
        rollDice()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rollDice()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        rollDice()
    }
    
    func rollDice() {
        randomDiceIndex1 = Int.random(min: 1, max: 6)
        randomDiceIndex2 = Int.random(min: 1, max: 6)
        
        dice1ImageView.image = UIImage(named: "dice\(randomDiceIndex1)")
        dice2ImageView.image = UIImage(named: "dice\(randomDiceIndex2)")
        
        showBingo(randomDiceIndex1 == randomDiceIndex2)
    }
    
    func showBingo (_ show : Bool) {
        bingoText.isHidden = !show
        bingoText.isEnabled = show
    }

}

