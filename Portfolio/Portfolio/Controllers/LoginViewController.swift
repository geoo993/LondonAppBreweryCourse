//
//  LoginViewController.swift
//  Onboard
//
//  Created by GEORGE QUENTIN on 12/01/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//
// https://www.youtube.com/watch?v=m_0_XQEfrGQ
// https://www.youtube.com/watch?v=sp8qEMY9X6Q&feature=youtu.be

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var textfield: LoginTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func startPortfolio(_ sender: UIButton) {
        if let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "HomeViewController")
            as? HomeViewController {
            
            vc.loadViewIfNeeded()
            vc.view.setNeedsLayout()
            vc.view.layoutIfNeeded()
            vc.keyChainservice = "geo"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func aboutPortfolio(_ sender: UIButton) {
        if let nav = self.navigationController, let pageVC =
            nav.viewControllers.first(where: { $0 is AboutPageViewController }) {
            nav.popToViewController(pageVC, animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("\(#function) \(self.className)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfield.delegate = self
    }
    
    deinit {
        print("\(#function) \(self.className)")
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    // MARK:- Textfield Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField did begin editing method called")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField did end editing method called")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField should and editing method called")
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        if let text = textfield.text, text.lowercased() == "geo" {
            loginButton.isEnabled = true
        }
        textField.resignFirstResponder()
        return true
    }
}
