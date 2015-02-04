//
//  ViewController.swift
//  Calculator
//
//  Created by Chi Phan on 2/2/15.
//  Copyright (c) 2015 Chi Phan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    let brain = CalculatorBrain()
    
    
    // var userInTheMiddleOfTypingANumber: Bool = false
    var userInTheMiddleOfTypingANumber = false
    var decimalTyped = false
   
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!

        // update the entered history
        // probably should get this from the model BrainCalculator.optStack instead of building it here
        history.text = history.text! + digit
        
        // only allow legal decimal numbers
        if (digit != ".") || (!decimalTyped && digit == ".")  {
            if userInTheMiddleOfTypingANumber {
                display.text = display.text! + digit
            } else {
                userInTheMiddleOfTypingANumber = true
                display.text = digit
            }
        }
        
        if digit == "." {
            decimalTyped = true
            
        }

        
    }

    @IBAction func operate(sender: UIButton) {

        // update the entered history
        history.text = history.text! + sender.currentTitle!

        if userInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
            
        }
    }
    

    
    // computed value to get double of displayed value
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            
        }
        set {
            display.text = "\(newValue)"
            userInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func enter() {
        userInTheMiddleOfTypingANumber = false
        decimalTyped = false
        
        // update the entered history
        history.text = history.text! + "="
        
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0  // want really to make displayValue optional and display nil
        }
        
    }
}

