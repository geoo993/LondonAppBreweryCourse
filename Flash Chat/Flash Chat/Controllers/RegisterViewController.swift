//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import FirebaseCore
import SVProgressHUD

class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGestureForHideKeyBoard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func registerUser(with email: String, and password: String) {
        
        SVProgressHUD.show()
        
        Auth
            .auth()
            .createUser(withEmail: emailTextfield.text!, 
                        password: passwordTextfield.text!, 
                        completion: { [weak self] (user, error) in
                guard let this = self else { return }
                if let user = user {
                    print("User Created: ", user)
                    this.performSegue(withIdentifier: "goToChat", sender: this)
                    SVProgressHUD.dismiss()
                }
                
                if let error = error {
                    print("Could not create user: ", error)
                    this.view.shakeView(repeatCount: 4)
                    SVProgressHUD.dismiss()
                }
        })
    }
  
    @IBAction func registerPressed(_ sender: AnyObject) {
        registerUser(with: emailTextfield.text!, and: passwordTextfield.text!)
    } 
}

extension RegisterViewController: UITextFieldDelegate {
   
    func addGestureForHideKeyBoard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK:- textfiled Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    //This gets called when the user taps the done button on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
}
