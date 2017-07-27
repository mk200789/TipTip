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
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    let tipPercentage = [0.15, 0.2, 0.25]

    @IBAction func onTap(_ sender: Any) {
        //dismiss the keyboard
        view.endEditing(true)
    }
    
    @IBAction func calculatingTip(_ sender: Any) {
        //when textfield has change edits calculate the tip
        let bill = Double(billTextField.text!) ?? 0
        let tip = bill * tipPercentage[tipControl.selectedSegmentIndex]
        let total = bill + tip
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
        updateDefaults(bill: bill, tip_amount: tip, total: total)
    }
    
    func updateDefaults(bill: Double, tip_amount: Double, total: Double){
        print("updateDefaults")
        //save bill and tip value to display when app loads
        let defaults = UserDefaults.standard
        defaults.set(tipControl.selectedSegmentIndex, forKey: "default_tip")
        defaults.set(bill, forKey: "previous_bill")
        defaults.set(total, forKey: "previous_total")
        defaults.set(tip_amount, forKey: "previous_tip_amount")
        defaults.synchronize()
    }
    
    func loadPreviousBill(){
        //load previous bill and values when app was last open
        print("loadPreviousBill")
        let defaults = UserDefaults.standard
        let bill = (defaults.object(forKey: "previous_bill") ?? 0) as! Int
        let tip = (defaults.object(forKey: "previous_tip_amount") ?? 0) as! Double
        let total = (defaults.object(forKey: "previous_total") ?? 0) as! Double
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        billTextField.text = String(format: "%D", bill)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //retrieve the default tip
        let defaults = UserDefaults.standard
        let default_tip = defaults.object(forKey: "default_tip") ?? 0
        tipControl.selectedSegmentIndex = default_tip as! Int
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadPreviousBill()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

