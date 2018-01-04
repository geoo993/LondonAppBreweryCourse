//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import FirebaseCore
import SVProgressHUD

class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGestureForHideKeyBoard()
    }

   
    func signInUser(with email: String, and password: String) {
        
        SVProgressHUD.show()
        
        Auth
            .auth()
            .signIn(withEmail: email, 
                    password: password, 
                    completion: { [weak self] (user, error) in
                        guard let this = self else { return }
                        if let user = user {
                            print("User Signed in: ", user)
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
    
   
    @IBAction func logInPressed(_ sender: AnyObject) {

        signInUser(with: emailTextfield.text!, and: passwordTextfield.text!)
        
    }
    
}  

extension LogInViewController: UITextFieldDelegate {
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
}
