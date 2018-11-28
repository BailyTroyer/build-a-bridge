//
//  FirstLastView.swift
//
//
//  Created by Baily Troyer on 7/26/18.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class EmailPasswordView: UIViewController {
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var firstName = String()
    var lastName = String()
    var phoneNumber = String()
    
    @IBAction func `return`(_ sender: Any) {
        self.performSegue(withIdentifier: "return_email", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //firstName.tintColor = .red
        
        warningLabel.text = ""
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.isTranslucent = false
        keyboardToolbar.barTintColor = UIColor.white
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(toProfilePic)
        )
        addButton.tintColor = UIColor.black
        keyboardToolbar.items = [addButton]
        email.inputAccessoryView = keyboardToolbar
        email.keyboardType = UIKeyboardType.emailAddress
        password.inputAccessoryView = keyboardToolbar
        
        
    }
    
    @objc func toProfilePic() {
        let charset = CharacterSet(charactersIn: "!#$%^&*()_+=-`~:,?")
        if email.text?.rangeOfCharacter(from: charset) != nil {
            warningLabel.text = "invalid characters in email"
            warningLabel.textColor = UIColor.red
        } else if email.text == "" {
            warningLabel.text = "please enter a valid email"
            warningLabel.textColor = UIColor.red
        } else if password.text == "" {
            warningLabel.text = "please enter a stronger password"
            warningLabel.textColor = UIColor.red
        } else {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
                if error != nil {
                    print("ERROR SIGNING UP USER: \(error?.localizedDescription)")
                    
                    self.warningLabel.textColor = UIColor.red
                    self.warningLabel.text = error?.localizedDescription
                } else {
                    let dname = "\(self.firstName) \(self.lastName)"
                    print("changing display name to : \(dname)")
                    
                    
                    //append to database

                    var ref: DatabaseReference!
                    
                    ref = Database.database().reference()
                    
                    ref.child("USERS").child("STATE").child("New York").child("REGION").child("Buffalo").child((Auth.auth().currentUser?.uid)!).setValue([
                        "email": Auth.auth().currentUser?.email,
                        "firstName": self.firstName,
                        "lastName": self.lastName,
                        "region": "Buffalo",
                        "state": "New York",
                        "userid": Auth.auth().currentUser?.uid
                        ])
                    
                    
                    
                    ref.child("USER_ID_DIRECTORY").child((Auth.auth().currentUser?.uid)!).setValue([
                        "email": Auth.auth().currentUser?.email,
                        "firstName": self.firstName,
                        "lastName": self.lastName,
                        "phoneNumber": self.phoneNumber,
                        "region": "Buffalo",
                        "state": "New York",
                        "userid": Auth.auth().currentUser?.uid
                        ])
                    
                    //end append
                    
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = dname
                    changeRequest?.commitChanges { (error) in
                        print(error?.localizedDescription)
                    }
                    self.performSegue(withIdentifier: "to_profile_pic", sender: self)
                }
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        email.becomeFirstResponder()
    }
    
}
