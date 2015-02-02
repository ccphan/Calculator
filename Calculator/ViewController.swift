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
    
    var userInTheMiddleOfTypingANumber: Bool = false
   
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            userInTheMiddleOfTypingANumber = true
            display.text = digit
        }
        
    }

}

