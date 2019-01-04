//
//  ViewController.swift
//  TransitionExample
//
//  Created by Moayad Al kouz on 8/8/17.
//  Copyright © 2017 malkouz. All rights reserved.
//

import UIKit
import AppCore

public class SwiftTransitionViewControllerBase: UIViewController,
UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {

    let transition = MTransition()
    let navTranstion = MNavigationTranstion()

    @IBOutlet weak var btnShow: UIButton!

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        return transition
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        return transition
    }

}
public class SwiftTransitionViewControllerPush: SwiftTransitionViewControllerBase {


    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK:- naviagation methods & delegate
    @IBAction func navBackAction(sender: UIBarButtonItem){
        self.navigationController?.dismiss(animated: true, completion: {

        })
    }


    @IBAction func pushAction(sender: UIButton){
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: "EmptyViewControllerPop")
        if let navigationVC = self.navigationController{
            navTranstion.startingPoint = btnShow.center
            navTranstion.circleColor = btnShow.backgroundColor!
            navigationVC.pushViewController(vc, animated: true)
        }
    }

    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        navTranstion.operation = operation
        navigationController.view.backgroundColor = self.view.backgroundColor
        return navTranstion
    }

}

public class SwiftTransitionViewControllerPresent: SwiftTransitionViewControllerBase {


    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK:- presentation methods & delegate
    @IBAction func backAction(sender: UIButton){
        self.dismiss(animated: true, completion: {
            
        })
    }
    
    @IBAction func presentAction(sender: UIButton){
        
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: "EmptyViewControllerDismiss")
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        transition.startingPoint = btnShow.center
        transition.circleColor = btnShow.backgroundColor!
        
        self.present(vc, animated: true, completion: nil)
        
    }

}

