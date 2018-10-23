//
//  VerifyPasswordView.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 10/11/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class VerifyPasswordView: UIViewController {
    
    @IBOutlet weak var password: UITextField!
    var setting: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.password.setBottomBorder()
    }
    
    @IBAction func enter_password(_ sender: Any) {
        
        //let user = Auth.auth().currentUser
        //let credential = FIREmailPasswordAuthProviderID.credentialWithEmail(user?.email, password: self.password.text)
        
        if self.password.text != "" {
            let credential = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email)!, password: self.password.text!)
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (error) in
                if error == nil {
                    self.setting = "3"
                    self.password.text = ""
                    self.performSegue(withIdentifier: "change_password", sender: self)
                } else {
                    print(error)
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ChangeSettingView
        {
            let vc = segue.destination as? ChangeSettingView
            vc?.setting = self.setting
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.password.becomeFirstResponder()
    }
}
