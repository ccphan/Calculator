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
    
    
    // var userInTheMiddleOfTypingANumber: Bool = false
    var userInTheMiddleOfTypingANumber = false
   
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            userInTheMiddleOfTypingANumber = true
            display.text = digit
        }
        
    }

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userInTheMiddleOfTypingANumber {
            enter()
        }
        
        switch operation {
            case "×": performOperation() { $0 * $1 }
            case "÷": performOperation() { $1 / $0 }
            case "+": performOperation() { $0 + $1 }
            case "−": performOperation() { $1 - $0 }
            case "√": performOperation() { sqrt($0) }
            default: break
        }
    }
    
    func performOperation(operation: (Double,Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = [Double]()
    
    @IBAction func enter() {
        userInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
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
}

