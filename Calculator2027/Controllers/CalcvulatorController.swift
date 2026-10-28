//
//  ViewController.swift
//  Calculator2027
//
//  Created by  User on 14.10.2026.
//

import UIKit

func sign(_ x:Double)-> Double {
    return -x
}

class CalcvulatorController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var display: UITextField!
    var isTyping = false
    var isZeroOperand = false
    
    
    override func viewDidLoad() {
        // Thay doi thuoc tinh cho button
        //btnDigit.layer.cornerRadius = 10
        //btnDigit.clipsToBounds = true
    }
    
    //MARK: Ham xu ly phim so
    @IBAction func digitProcessing(_ sender: UIButton) {
        let digit = sender.titleLabel!.text!
        let currentDisplay = display.text!
        // Truong hop chu co so nao => Ghi de
        if !isTyping {
            display.text = digit
            // Thay doi trang thai
            if digit != "0" {
                isTyping = true
            }
            else {
                // Co kha nang so 0 la toan hang
                isZeroOperand = true
            }
        }
        else { // Noi so
            display.text = currentDisplay + digit
        }
    }
    
    //MARK: Bien tinh toan trung gian giua phuong thuc functionProcessing va MH display
    var displayValue:Double? {
        get {
            if let strNumber = display.text, let number = Double(strNumber) {
                return number
            }
            else {
                return nil
            }
        }
        set {
            if let value = newValue {
                if !value.isNaN {
                    let pn = newValue!.soChuSoPhanNguyen()
                    let ptp = newValue!.soChuSoPhanThapPhan()
                    if pn + ptp <= 12 { // Khong can lam tron
                        if ptp == 0 {
                            display.text = String(format: "%.0f", newValue!)
                        }
                        else {
                            display.text = String(newValue!)
                        }
                    }
                    else {
                        display.text = String(format: "%.\(12-pn)f", newValue!)
                    }
                }
                else {
                    display.text = String(Double.nan)
                }
            }
        }
    }
    
    //MARK: Khai bao doi tuong M (CalculatorBrain)
    let brain = CalculatorBrain()
    
    //MARK: Ham xu ly chuc nang
    @IBAction func functionProcessing(_ sender: UIButton) {
        // Xu ly cac truong hop tinh toan
        let functionSymbol = sender.titleLabel!.text!
        // Gui cac tham so cho M
        if let value = displayValue {
            // B1. Gui gia tri can tinh cho M khi nguoi dung go gia tri toan hang
            if isTyping {
                brain.sendOperand(value)
            }
            else {
                if isZeroOperand {
                    brain.sendOperand(value)
                    // Xoa co
                    isZeroOperand = false
                }
            }
            // B2. Gui phep toan cho M
            brain.performMathFunction(functionSymbol)
        }
        // Lay ket qua tra ve tu M
        displayValue = brain.result
        
        // Xoa trang thai phim so
        isTyping = false
    }
}
extension Double {
    func soChuSoPhanNguyen()->Int {
        return (self.isNaN||self.isInfinite) ? -1 : String(self).split(separator: ".")[0].count
    }
    func soChuSoPhanThapPhan() ->Int {
        return (self.isNaN||self.isInfinite) ? -1 : String(self).split(separator: ".")[1] == "0" ? 0 : String(self).split(separator: ".")[1].count
    }
}


