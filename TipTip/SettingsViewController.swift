//
//  SettingsViewController.swift
//  TipTip
//
//  Created by Wan Kim Mok on 7/27/17.
//  Copyright © 2017 Wan Kim Mok. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    
    @IBAction func setDefaultTip(_ sender: Any) {
        //set default tip
        let defaults = UserDefaults.standard
        defaults.set(defaultTipControl.selectedSegmentIndex, forKey: "default_tip")
        defaults.synchronize()
        SETTINGS_CHANGES = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let default_tip = defaults.object(forKey: "default_tip") ?? 0
        defaultTipControl.selectedSegmentIndex = default_tip as! Int
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
