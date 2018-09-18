//
//  SettingsView.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 8/23/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SettingsView: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fName: UILabel!
    @IBOutlet weak var lName: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    
//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var fName: UILabel!
//    @IBOutlet weak var lName: UILabel!
//    @IBOutlet weak var emailAddress: UILabel!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background image
        let profPicStorage = Storage.storage(url:"gs://build-a-bridge-207816.appspot.com")
        
        let picRref = profPicStorage.reference().child("PROFILE_PICTURES/\((Auth.auth().currentUser?.uid)! + ".jpeg")")
        
        
        picRref.getData(maxSize: 15 * 1024 * 1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                // Data for "images/island.jpg" is returned
                let profImage = UIImage(data: data!)
                self.imageView.image = profImage
            }
        }
        
        // database
        
    
        self.ref.child("USERS").child("STATE").child("NEW_YORK").child("REGION").child("BUFFALO").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let contents = snapshot.value as? NSDictionary
            
            var f = (contents?.value(forKey: "firstName") as? String)!
            var l = (contents?.value(forKey: "lastName") as? String)!
            
            var e = (contents?.value(forKey: "email") as? String)!
        
            print("name: \(f)")
            
            self.emailAddress.text = e
            self.fName.text = f
            self.lName.text = l
        })
        
        
        self.imageView.layer.cornerRadius = self.imageView.frame.height/2
        self.imageView.layer.masksToBounds = true

        navigationItem.title = "Edit Account"
    }
}