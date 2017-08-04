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
    
    @IBOutlet weak var greyThemeButton: UIButton!
    @IBOutlet weak var blueThemeButton: UIButton!
    @IBOutlet weak var purpleThemeButton: UIButton!
    
    
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
        let default_theme = defaults.colorForKey(key: "default_theme") ?? UIColor.white //defaults.object(forKey: "default_theme") ?? UIColor.white
        
        defaultTipControl.selectedSegmentIndex = default_tip as! Int
        self.view.backgroundColor = default_theme
        
        
        
        
    }
    
    
    @IBAction func changeTheme(_ sender: UIButton){
        //change the theme based on theme button selected button selected
        self.view.backgroundColor = sender.backgroundColor
        let defaults = UserDefaults.standard
        defaults.setColor(color: sender.backgroundColor, forKey: "default_theme")
        defaults.synchronize()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        blueThemeButton.layer.cornerRadius = 5.0
        blueThemeButton.layer.borderWidth = 0.25
        blueThemeButton.layer.borderColor = UIColor.darkGray.cgColor
        
        purpleThemeButton.layer.cornerRadius = 5.0
        purpleThemeButton.layer.borderWidth = 0.25
        purpleThemeButton.layer.borderColor = UIColor.darkGray.cgColor
        
        greyThemeButton.layer.cornerRadius = 5.0
        greyThemeButton.layer.borderWidth = 0.25
        greyThemeButton.layer.borderColor = UIColor.darkGray.cgColor

        
        
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



extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key)
    }
    
}
