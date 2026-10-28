
//
//  CalcvulatorController.swift
//  Calculator2027
//
//  Created by User on 14.10.2026.
//

import UIKit

// MARK: Calculator Controller

class CalculatorController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var display: UITextField!
    var isTyping = false
    var isZeroOperand = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        display.text = "0"
    }

    //MARK: Ham xu ly phim so
    @IBAction func digitProcessing(_ sender: UIButton) {
        let digit = sender.titleLabel!.text!
        let currentDisplay = display.text!
        if !isTyping {
            display.text = digit
            if digit != "0" {
                isTyping = true
            }
            else{
                //co kha nang so 0 la toan hang
                isZeroOperand = true
            }
        }
        else {
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
            if let value = newValue{
                if !value.isNaN{
                    let pn = newValue!.soChuSoPhanNguyen()
                    let ptp = newValue!.soChuSoPhanThapPhan()
                    if pn + ptp <= 12 { // Khong can lam tron
                        if ptp == 0{
                            display.text = String(newValue!)
                        }
                        else {
                            display.text = String(format: "%.\(max(0,12-pn))f", newValue!)
                        }
                    }
                    else{display.text=String(Double.nan)}
                }
            }
        }
    }
    //MARK: Khai bao doi tuong M. CalculatorBrain
    let brain = CaculatorBrain()
    
    //MARK: Ham xu ly chuc nang
    @IBAction func functionProcessing(_ sender: UIButton) {
        // Xu ly cac truong hop tinh toan
        let functionSymbol = sender.titleLabel!.text!
        //gui gia tri can tinh cho M
        if let value  = displayValue{
            //B1. gui gia tri can tinh cho M khi nguoi dung go gia tri toan ham
            if isTyping{
                brain.sendOperand(value)
            }
            else{
                if isZeroOperand{
                    brain.sendOperand(value)
                    isZeroOperand = false
                }
            }
            //B2. Gio phep toan cho M
            brain.performMathFunction(functionSymbol)
        }
        //lay ket qua tra ve tu M
        displayValue = brain.result
        
        // Xoa trang thai phim so
        isTyping = false
    }
}

extension Double {
    func soChuSoPhanNguyen()->Int {
        return (self.isNaN || self.isInfinite) ? -1 : String(self).split(separator: ".")[0].count
    }
    func soChuSoPhanThapPhan()->Int {
       // let soChuSoDung = self
        return (self.isNaN || self.isInfinite) ? -1 : String(self).split(separator: ".")[1] == "0" ? 0 : String(self).split(separator: ".")[1].count
    }
}
