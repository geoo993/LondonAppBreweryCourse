//
//  SecondViewController.swift
//  TransitionExample
//
//  Created by Moayad Al kouz on 8/8/17.
//  Copyright © 2017 malkouz. All rights reserved.
//

import UIKit


public class EmptyViewControllerBase: UIViewController {

    @IBOutlet weak var btnHide: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

}

public class EmptyViewControllerPop: EmptyViewControllerBase {

    @IBAction func popAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

public class EmptyViewControllerDismiss: EmptyViewControllerBase {
    @IBAction func dismissAction(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }

}
