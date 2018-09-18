//
//  FirstLastView.swift
//  
//
//  Created by Baily Troyer on 7/26/18.
//

import Foundation
import UIKit

class FirstLastView: UIViewController {

    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBAction func goBack(_ sender: Any) {
        self.performSegue(withIdentifier: "back_to", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.tintColor = .red
        
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.isTranslucent = false
        keyboardToolbar.barTintColor = UIColor.white
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(to_email)
        )
        addButton.tintColor = UIColor.black
        keyboardToolbar.items = [addButton]
        firstName.inputAccessoryView = keyboardToolbar
        lastName.inputAccessoryView = keyboardToolbar
        phoneNumber.inputAccessoryView = keyboardToolbar
        warningLabel.text = ""
        
        phoneNumber.keyboardType = UIKeyboardType.decimalPad
        
    }
    
    @objc func to_email() {
        if (firstName.text != "" && lastName.text != "" && phoneNumber.text != "") {
            self.performSegue(withIdentifier: "to_email", sender: self)
        } else {
            warningLabel.text = "enter a first, last name and phone number"
            warningLabel.textColor = UIColor.red
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EmailPasswordView {
            print("IT IS HAPPENING")
            vc.firstName = self.firstName.text!
            vc.lastName = self.lastName.text!
            vc.phoneNumber = self.phoneNumber.text!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        firstName.becomeFirstResponder()
    }

}
