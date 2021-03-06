//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Chi Phan on 2/3/15.
//  Copyright (c) 2015 Chi Phan. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: Printable {  // implement Printable protocol which is just the computed property description
    case Operand(Double)  // associate a double with enumerated case
    case UniaryOperation(String, Double -> Double)  // associate function with this case
    case BinaryOperation(String, (Double, Double) -> Double)
   
    // convert enum members into strings - for debugging
    var description: String {
        get {
            switch self {
            case .Operand(let operand):
                return "\(operand)"
            case .UniaryOperation(let symbol, _):
                return symbol
            case .BinaryOperation(let symbol, _):
                return symbol
            }
        }
    }
    }
    
    private var optStack = [Op]()
    
    // var knownOps = Dictionary<String, Op>()
    private var knownOps = [String: Op]()
    
    init() {
        // knownOps["×"] = Op.BinaryOperation("×", { $0 * $1 })
        // knownOps["×"] = Op.BinaryOperation("×") { $0 * $1 }
        knownOps["×"] = Op.BinaryOperation("×", * )
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        // knownOps["+"] = Op.BinaryOperation("+") { $0 + $1 }
        knownOps["+"] = Op.BinaryOperation("+", + )
        // knownOps["√"] = Op.UniaryOperation("√") { sqrt($0) }
        knownOps["√"] = Op.UniaryOperation("√", sqrt )
    }
    
    // recursive function to pop operation and operands off the stack and evaluate
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            var remainingOps = ops  // remember arguments are read only
            let op = remainingOps.removeLast()  // pop element off the stack
            
            // evaulate the enum
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UniaryOperation( _ , let operation):  // the _ means you don't really care about this argument
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return(operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
                
                
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(optStack)
        // debug
        println("\(optStack) = \(result) with \(remainder) left over")
        return result
    }
    
    
    func pushOperand(operand: Double) -> Double? {
        optStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            optStack.append(operation)
        }
        
        return evaluate()
    }
}
