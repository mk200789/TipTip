//
//  ViewController.swift
//  TipTip
//
//  Created by Wan Kim Mok on 7/26/17.
//  Copyright © 2017 Wan Kim Mok. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var billTextField: UITextField!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var billViewContainer: UIView!
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    let tipPercentage = [0.15, 0.2, 0.25]
    
    let formatter = NumberFormatter()
    
    @IBOutlet weak var splitBillAmount: UILabel!

    @IBOutlet weak var splitBillStepper: UIStepper!

    @IBOutlet weak var numberSplit: UILabel!
    
    @IBOutlet weak var billTextView: UIView!
    
    @IBOutlet weak var calculationTextView: UIView!
    
    @IBOutlet weak var divider: UIView!
    
    @IBAction func onTap(_ sender: Any) {
        //dismiss the keyboard
        view.endEditing(true)
    }
    
    @IBAction func calculatingTip(_ sender: Any) {
        //when textfield has change edits calculate the tip
        
        let bill = convertCurrencyStringToDouble(amount: billTextField.text!)
        let tip = bill * tipPercentage[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        tipLabel.text = formatter.string(for: tip)!
        totalLabel.text = formatter.string(for: total)!
        
        let splitAmount = total/splitBillStepper.value
        numberSplit.text = String(describing: Int(splitBillStepper.value))
        splitBillAmount.text = String(format: "%@%.2f", Locale.current.currencySymbol!, splitAmount)
        
        updateDefaults(bill: bill, tip_amount: tip, total: total, split: splitBillStepper.value, splitTotal: splitAmount)
    }
    
    @IBAction func calculateSplitBill(_ sender: Any) {
        //calculate the split bill by the number of people to split among equally
        let total = convertCurrencyStringToDouble(amount: totalLabel.text!)
        let splitAmount = total/splitBillStepper.value
        numberSplit.text = String(describing: Int(splitBillStepper.value))
        splitBillAmount.text = String(format: "%@%.2f", Locale.current.currencySymbol!, splitAmount)
        
    }
    
    @IBAction func touchOutside(_ sender: Any) {
        //handles touching outside of the billtextfield
        UIView.animate(withDuration: 0.4) {
            self.billViewContainer.bounds.size.height = 216
            self.billViewContainer.bounds.size.width = self.view.bounds.size.width
            self.billViewContainer.frame.origin.y = (self.navigationController?.toolbar.bounds.size.height)!
            
            self.billTextField.frame.origin.y = self.billTextField.frame.origin.y - 40
        }
    }
    
    @IBAction func touchInside(_ sender: Any) {
        //handles touching inside of the billtextfield
        clearValue()
        UIView.animate(withDuration: 0.4) {
            self.billViewContainer.bounds.size.height = self.view.bounds.size.height
            self.billViewContainer.bounds.size.width = self.view.bounds.size.width
            self.billViewContainer.frame.origin.y = (self.navigationController?.toolbar.bounds.size.height)!
            
            self.billTextField.frame.origin.y = self.billTextField.frame.origin.y + 40
            self.view.bringSubview(toFront: self.billViewContainer)
        }
    }
    
    func updateDefaults(bill: Double, tip_amount: Double, total: Double, split: Double, splitTotal: Double){
        
        //save bill and tip value to display when app loads
        let defaults = UserDefaults.standard
        defaults.set(tipControl.selectedSegmentIndex, forKey: "default_tip")
        defaults.set(bill, forKey: "previous_bill")
        defaults.set(total, forKey: "previous_total")
        defaults.set(tip_amount, forKey: "previous_tip_amount")
        defaults.set(split, forKey: "previous_split")
        defaults.set(splitTotal, forKey: "previous_splitTotal")
        defaults.synchronize()
    }
    
    
    func clearValue(){
        //clears the value of everything
        billTextField.text = ""
        tipLabel.text = ""
        totalLabel.text = ""
        splitBillAmount.text = ""
        updateDefaults(bill: 0.0, tip_amount: 0.0, total: 0.0, split: splitBillStepper.value, splitTotal: 0.0)
    }
    
    func loadPreviousBill(){
        //load previous bill and values when app was last open
        let defaults = UserDefaults.standard
        let bill = (defaults.object(forKey: "previous_bill") ?? 0) //as! Int
        let tip = (defaults.object(forKey: "previous_tip_amount") ?? 0) //as! Double
        let total = (defaults.object(forKey: "previous_total") ?? 0) //as! Double
        let split = (defaults.object(forKey: "previous_split") ?? 1.0)
        let splitTotal = (defaults.object(forKey: "previous_splitTotal") ?? 0)
        
        tipLabel.text = formatter.string(for: tip)!
        totalLabel.text = formatter.string(for: total)!
        billTextField.text = formatter.string(for: bill)!
        numberSplit.text = String(describing: split as! Int)
        splitBillStepper.value = split as! Double
        splitBillAmount.text = formatter.string(for: splitTotal)!
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = Locale.current
        formatter.currencySymbol = Locale.current.currencySymbol
        
        //retrieve the default tip
        let defaults = UserDefaults.standard
        let default_tip = defaults.object(forKey: "default_tip") ?? 0
        let default_theme = defaults.colorForKey(key: "default_theme") ?? UIColor.white
        
        tipControl.selectedSegmentIndex = default_tip as! Int
        billTextView.backgroundColor = default_theme
        calculationTextView.backgroundColor = default_theme.adjust(by: -30)
        divider.backgroundColor = default_theme.adjust(by: -10)
        if (SETTINGS_CHANGES){
            calculatingTip([])
        }else{
            loadPreviousBill()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func convertCurrencyStringToDouble(amount: String) -> Double {
        //convert string to double
        let converter = NumberFormatter()
        //convert amount if it has a comma in the string
        converter.decimalSeparator = ","
        if let result = converter.number(from: amount){
            return result.doubleValue
        }else{
            //convert amount if it has a period in the string
            converter.decimalSeparator = "."
            if let result = converter.number(from: amount){
                return result.doubleValue
            }
        }
        
        //if amount string contains currency symbol convert it to nsnumber to return a double value
        converter.numberStyle = NumberFormatter.Style.currency
        converter.locale = Locale.current
        converter.currencySymbol = Locale.current.currencySymbol
        
        if let bill_number = converter.number(from: amount){
            return bill_number.doubleValue
        }
        
        return 0.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension UIColor {
    
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
}

