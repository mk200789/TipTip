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

        updateDefaults(bill: bill, tip_amount: tip, total: total)
        
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
    
    func updateDefaults(bill: Double, tip_amount: Double, total: Double){
        
        //save bill and tip value to display when app loads
        let defaults = UserDefaults.standard
        defaults.set(tipControl.selectedSegmentIndex, forKey: "default_tip")
        defaults.set(bill, forKey: "previous_bill")
        defaults.set(total, forKey: "previous_total")
        defaults.set(tip_amount, forKey: "previous_tip_amount")
        defaults.synchronize()
    }
    
    
    func clearValue(){
        print("clearValue")
        billTextField.text = ""
        updateDefaults(bill: 0.0, tip_amount: 0.0, total: 0.0)
    }
    
    func loadPreviousBill(){
        //load previous bill and values when app was last open
        let defaults = UserDefaults.standard
        let bill = (defaults.object(forKey: "previous_bill") ?? 0) //as! Int
        let tip = (defaults.object(forKey: "previous_tip_amount") ?? 0) //as! Double
        let total = (defaults.object(forKey: "previous_total") ?? 0) //as! Double
        
        tipLabel.text = formatter.string(for: tip)!
        totalLabel.text = formatter.string(for: total)!
        billTextField.text = formatter.string(for: bill)!

    }
    
    override func viewWillAppear(_ animated: Bool) {
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = Locale.current
        formatter.currencySymbol = Locale.current.currencySymbol
        
        //retrieve the default tip
        let defaults = UserDefaults.standard
        let default_tip = defaults.object(forKey: "default_tip") ?? 0
        tipControl.selectedSegmentIndex = default_tip as! Int

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

