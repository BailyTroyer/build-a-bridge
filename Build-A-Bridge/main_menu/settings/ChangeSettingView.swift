//
//  ChangeSettingView.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 10/10/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class ChangeSettingView: UIViewController {
    
    @IBOutlet weak var fieldChanged: UITextField!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var changeSettingButton: UIButton!
    @IBOutlet weak var settingItem: UITextField!
    var setting: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.fieldChanged.setBottomBorder()
        
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
        if self.setting == "3" {
            if self.fieldChanged.text != nil {
                Auth.auth().currentUser!.updatePassword(to: self.fieldChanged.text!) { (errror) in
                    print(errror)
                }
            }
        } else if self.setting == "2" {
            if self.fieldChanged.text != "" {
                Auth.auth().currentUser?.updateEmail(to: self.fieldChanged.text!) { (error) in
                    print("error")
                }
            }
        } else if self.setting == "1" {
            print("coming soon!")
            
        } else if self.setting == "0" {
            print("coming soon!")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fieldChanged.becomeFirstResponder()
    }
    
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

//let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//changeRequest?.displayName = displayName
//changeRequest?.commitChanges { (error) in
//    // ...
//}
