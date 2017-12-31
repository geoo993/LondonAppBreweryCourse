//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit


//Write the protocol declaration here:
protocol ChangeCityDelegate {
    func userEnteredANewCityName(cityName: String)
}


class ChangeCityViewController: UIViewController, UITextFieldDelegate {
    
    //Declare the delegate variable here:
    var delegate : ChangeCityDelegate? 
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

  
    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGestureForHideKeyBoard()
    }
    
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
        self.changeCity(city: textField.text)
        return true
    }

    func changeCity(city: String?) {
        if 
            let cityName = city, 
            let delegate = self.delegate {
            delegate.userEnteredANewCityName(cityName: cityName)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
