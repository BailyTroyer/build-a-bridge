//
//  ChangeSettingView.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 10/10/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit

class ChangeSettingView: UIViewController {
    
    @IBOutlet weak var fieldChanged: UITextField!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var changeSettingButton: UIButton!
    @IBOutlet weak var settingItem: UITextField!
    var setting: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("setting is: \(self.setting)")
        if self.setting == "0" {
            self.settingLabel.text = "First Name"
            self.changeSettingButton.setTitle("UPDATE FIRST NAME", for: .normal)
        } else if self.setting == "1" {
            self.settingLabel.text = "Last Name"
            self.changeSettingButton.setTitle("UPDATE LAST NAME", for: .normal)
        } else if self.setting == "2" {
            self.settingLabel.text = "Email"
            self.changeSettingButton.setTitle("UPDATE EMAIL", for: .normal)
        } else if self.setting == "3" {
            self.settingLabel.text = "Password"
            self.changeSettingButton.setTitle("UPDATE PASSWORD", for: .normal)
        }
    }
    
    @IBAction func updateSetting(_ sender: Any) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fieldChanged.becomeFirstResponder()
    }
}
