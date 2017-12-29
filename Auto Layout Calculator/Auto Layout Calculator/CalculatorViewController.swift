//
//  CalculatorViewController.swift
//  Auto Layout Calculator
//
//  Created by GEORGE QUENTIN on 29/12/2017.
//  Copyright © 2017 Geo Games. All rights reserved.
//

import UIKit
import AppCore

public enum Operator {
    case add, subtract, multiply, divide
}

public class CalculatorViewController: UIViewController {
    
    var result : CGFloat? = nil {
        didSet {
            guard let result = result else { return }
            numberSaved = result
            let resultString = "\(result) "
            label.text = resultString.contains(".0 ") ? "\(Int(result))" : "\(result)"
        }
    }
    var isDecimal = false
    var currentNumber : CGFloat = 0
    var numberSaved : CGFloat = 0
    var numbersAsString = [String]()
    var currentOperator : Operator = .add {
        didSet {
            
            if let result = result {
                self.numberSaved = result
            }else {
                self.numberSaved = currentNumber 
            }
            self.numbersAsString.removeAll()
            self.currentNumber = 0
            self.isDecimal = false
        }
    }
    
    @IBOutlet weak var label : UILabel!
    
    @IBAction func numbersPressed ( _ sender : UIButton ) {
        let numberTapped = (sender.tag == 10) ? 0 : sender.tag 
        numbersAsString.append("\(numberTapped)")
        let numberString = numbersAsString.joined()
        
        if let number = Double(numberString) {
            currentNumber = CGFloat(number)
            label.text = numberString
        }
    }
    
    @IBAction func clearPressed ( _ sender : UIButton ) {
        self.clearAll()
        label.text = "0"
    }
    
    @IBAction func equalsPressed ( _ sender : UIButton ) {
        if self.calculateResult() {
            self.numbersAsString.removeAll()
        }
    }
    
    @IBAction func dotPressed ( _ sender : UIButton ) {
        
        if isDecimal == false {
            self.numbersAsString.append(".")
            isDecimal = true
        }
    }
    
    @IBAction func subtractPressed ( _ sender : UIButton ) {
        currentOperator = .subtract
    }
    
    @IBAction func addPressed ( _ sender : UIButton ) {
        currentOperator = .add
    }
    
    @IBAction func mulitplyPressed ( _ sender : UIButton ) {
        currentOperator = .multiply
    }
    
    @IBAction func dividePressed ( _ sender : UIButton ) {
        currentOperator = .divide
    }
    
    func calculateResult () -> Bool {
        switch currentOperator {
        case .add:
            self.result = (numberSaved + currentNumber)
            return true
        case .subtract:
            self.result = (numberSaved - currentNumber)
            return true
        case .divide:
            self.result = (numberSaved / currentNumber)
            return true
        case .multiply:
            self.result = (numberSaved * currentNumber)
            return true
        }
    }
    
    func clearAll() {
        result = nil
        numberSaved = 0
        currentNumber = 0
        numbersAsString.removeAll()
        isDecimal = false
    }

}

