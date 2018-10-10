//
//  SplashScreen.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 7/18/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SplashScreen: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        setupKeyboardDismissRecognizer()
        
        warningLabel.text = ""
    }
    
    func setupKeyboardDismissRecognizer() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        let border = CALayer()
        let _width = CGFloat(1)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: emailField.frame.size.height - _width, width: emailField.frame.size.width, height: emailField.frame.size.height)
        border.borderWidth = _width
        emailField.layer.addSublayer(border)
        emailField.layer.masksToBounds = true
        
        let border_pass = CALayer()
        let width_pass = CGFloat(1)
        border_pass.borderColor = UIColor.white.cgColor
        border_pass.frame = CGRect(x: 0, y: passwordField.frame.size.height - width_pass, width: passwordField.frame.size.width, height: passwordField.frame.size.height)
        border_pass.borderWidth = width_pass
        passwordField.layer.addSublayer(border_pass)
        passwordField.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func logIn(_ sender: Any) {
        if emailField.text != "" && passwordField.text != "" {
            
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                
                if error != nil {
                    //error
                    self.warningLabel.text = error?.localizedDescription
                    print("error: \(String(describing: error))")
                } else {
                    print("user: \(String(describing: user))")
                    
                    self.performSegue(withIdentifier: "to_menu", sender: self)
                }
                
            }
            
        } else {
            warningLabel.text = "enter an email and password"
        }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.performSegue(withIdentifier: "to_splash", sender: self)
    }
    
    
}

