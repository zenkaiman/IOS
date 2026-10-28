//
//  CalculatorBrain.swift
//  Calculator2027
//
//  Created by  User on 25.10.2026.
//

import UIKit

class CalculatorBrain {
    //MARK: Cac bien thanh phan cua M
    private var accumulator:Double?
    // Dinh nghia cau truc luu toan hang 1 va phep toan
    struct Pending {
        var firstOperand:Double
        var function:(Double, Double)->Double
    }
    // Dinh nghia bien thanh phan de luu du lieu phep 2 ngoi
    private var pending: Pending? = nil
    
    //MARK: Cac phuong thuc cua lop M
    func sendOperand(_ operand: Double){
        // Luu gia tri de xu ly sau
        accumulator = operand
    }
    // Phuong thuc thuc hien phep toan
    func performMathFunction(_ function:String) {
        switch function {
        case "e": accumulator = M_E
        case "𝜋": accumulator = Double.pi
        case "√": if let number = accumulator {
            accumulator = sqrt(number)
        }
        case "cos": if let number = accumulator {
            accumulator = cos(number)
        }
        case "∓": if let number = accumulator {
            accumulator = sign(number)
        }
        case "−":
            // Luu phep toan va toan hang 1
            if let value = accumulator {
                pending = Pending(firstOperand: value, function: {(a:Double, b:Double) in a - b})
                accumulator = nil
            }
        case "+":
            // Luu phep toan va toan hang 1
            if let value = accumulator {
                pending = Pending(firstOperand: value, function: {(a:Double, b:Double) in a + b})
                accumulator = nil
            }
        case "×":
            // Luu phep toan va toan hang 1
            if let value = accumulator {
                pending = Pending(firstOperand: value, function: {(a:Double, b:Double) in a * b})
                accumulator = nil
            }
        case "÷":
            // Luu phep toan va toan hang 1
            if let value = accumulator {
                pending = Pending(firstOperand: value, function: {(a:Double, b:Double) in a / b})
                accumulator = nil
            }
        case "=":
            // Thuc hien phep toan 2 ngoi
            if let secondOperand = accumulator, let pending = pending {
                accumulator = pending.function(pending.firstOperand, secondOperand)
                self.pending = nil
            }
        default : break
        }
    }
    //MARK: Dinh nghia bien tinh toan de C lay ket qua tra ve tu M
    var result:Double? {
        get {
            return accumulator
        }
    }
}
