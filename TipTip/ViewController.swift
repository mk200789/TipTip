//
//  ViewController.swift
//  TipTip
//
//  Created by Wan Kim Mok on 7/26/17.
//  Copyright © 2017 Wan Kim Mok. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let formatter = NumberFormatter()
    
    @IBOutlet weak var billTextField: UITextField!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var billViewContainer: UIView!
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var splitBillAmount: UILabel!

    @IBOutlet weak var splitBillStepper: UIStepper!

    @IBOutlet weak var numberSplit: UILabel!
    
    @IBOutlet weak var billTextView: UIView!
    
    @IBOutlet weak var calculationTextView: UIView!
    
    @IBOutlet weak var divider: UIView!
    
    @IBOutlet weak var divider2: UIView!
    
    @IBAction func onTap(_ sender: Any) {
        //dismiss the keyboard
        view.endEditing(true)
    }
    
    @IBAction func calculatingTip(_ sender: Any) {
        //calculates the tip
        let bill = convertCurrencyStringToDouble(amount: billTextField.text!)
        let tip = bill * tipPercentage[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        tipLabel.text = formatter.string(for: tip)!
        totalLabel.text = formatter.string(for: total)!
        
        let splitAmount = total/splitBillStepper.value
        numberSplit.text = String(describing: Int(splitBillStepper.value))
        splitBillAmount.text = String(format: "%@%.2f", Locale.current.currencySymbol!, splitAmount)
        
        setBill(bill: bill)
    }
    
    func setPlacementHolders(){
        //sets the placeholder to 0.00 USD or the phone system's currency
        let defaultValue = formatter.string(from: NSNumber(value: 0.00))
        billTextField.placeholder = String(format: "%@%.2f", Locale.current.currencySymbol!, defaultValue!)
        tipLabel.text = String(format: "%@%.2f", Locale.current.currencySymbol!, defaultValue!)
        totalLabel.text = String(format: "%@%.2f", Locale.current.currencySymbol!, defaultValue!)
        splitBillAmount.text = String(format: "%@%.2f", Locale.current.currencySymbol!, defaultValue!)
        numberSplit.text = String(describing: Int(splitBillStepper.value))
    }
    
    func setBill(bill: Double){
        //save bill and tip value to display when app loads
        let defaults = UserDefaults.standard
        defaults.set(bill, forKey: "lastBill")
        defaults.set(tipControl.selectedSegmentIndex, forKey: "default_tip")
        defaults.set(splitBillStepper.value, forKey: "previous_split")
        defaults.set(NSDate.init(), forKey: "lastBillDate")
        defaults.synchronize()
    }
    
    func clearValue(){
        //clears the value of everything
        setBill(bill: 0.0)
    }
    
    func loadPreviousBill(){
        //load previous bill and values when app was last open
        let defaults = UserDefaults.standard
        let bill = (defaults.object(forKey: "lastBill") ?? 0) as! Double
        let split = (defaults.object(forKey: "previous_split") ?? 1) as! Int
        let tipIndex = (defaults.object(forKey: "default_tip") ?? 0) as! Int
        
        let tip = bill * tipPercentage[tipIndex]
        let total = bill + tip
        let splitTotal = total/Double(split)

        
        tipLabel.text = formatter.string(for: tip)!
        totalLabel.text = formatter.string(for: total)!
        billTextField.text = String(describing: bill)
        numberSplit.text = String(describing: split)
        splitBillStepper.value = Double(split)
        splitBillAmount.text = formatter.string(for: splitTotal)!
    }
    
    func loadSettings(){
        //retrieve the default settings
        let defaults = UserDefaults.standard
        let default_tip = defaults.object(forKey: "default_tip") ?? 0
        let default_theme = defaults.colorForKey(key: "default_theme") ?? self.view.backgroundColor
        
        tipControl.selectedSegmentIndex = default_tip as! Int
        self.navigationController?.navigationBar.barTintColor = default_theme
        self.view.backgroundColor = default_theme
        billTextView.backgroundColor = default_theme
        calculationTextView.backgroundColor = default_theme?.adjust(by: -30)
        divider.backgroundColor = default_theme?.adjust(by: -10)
        divider2.backgroundColor = default_theme?.adjust(by: -20)
        
        billTextField.adjustsFontSizeToFitWidth = true
        totalLabel.adjustsFontSizeToFitWidth = true
        splitBillAmount.adjustsFontSizeToFitWidth = true
        
    }
    
    func removeNavigationBarHairline() {
        //remove the bar hairline on the navigation bar
        let image = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = image
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    
    func getCurrency(){
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = Locale.current
        formatter.currencySymbol = Locale.current.currencySymbol
    }
    
    override func viewWillAppear(_ animated: Bool) {
        removeNavigationBarHairline()
        
        loadSettings()
        
        
        if (SETTINGS_CHANGES){
            calculatingTip([])
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getCurrency()
        
        setPlacementHolders()
        
        loadSettings()
        
        let lastBillDate = UserDefaults.standard.object(forKey: "lastBillDate")
        
        if (lastBillDate != nil){
            //clear value if 10 minutes has passed
            if ((NSDate.init().timeIntervalSince(lastBillDate as! Date) < 6000)){
                loadPreviousBill()
            }else{
                clearValue()
            }
        }
        
        billTextField.becomeFirstResponder()
        
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
