//
//  HomeView.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 7/18/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

struct ticket {
    var title:String
    var name:String
    //var details:String
}

class HomeView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var leading_constraint: NSLayoutConstraint!
    @IBOutlet weak var slide_view: UIView!
    @IBOutlet weak var ticketView: UITableView!
    
    var menu_showing = false
    var ref = Database.database().reference()
    
    var selectedSkill = String()
    
    var requestUIDS = [Any]()
    var titles = [Any]()
    var names = [Any]()
    var uids = [Any]()
    var images = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isToolbarHidden = true
        
        userName.text = Auth.auth().currentUser?.displayName
        print("display name: \(Auth.auth().currentUser?.displayName)")
        
        warningLabel.text = ""
        
        //background image
        let profPicStorage = Storage.storage(url:"gs://build-a-bridge-207816.appspot.com")
        
        let picRref = profPicStorage.reference().child("PROFILE_PICTURES/\((Auth.auth().currentUser?.uid)! + ".jpeg")")
        
        
        picRref.getData(maxSize: 15 * 1024 * 1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                // Data for "images/island.jpg" is returned
                let profImage = UIImage(data: data!)
                self.profilePicture.image = profImage
            }
        }
        
        leading_constraint.constant = -240
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.layer.masksToBounds = true
        
        self.ref.child("REQUESTS").child("STATE").child("NEW_YORK").child("REGION").child("BUFFALO").child("REQUESTED").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            //print(value)
            
            if snapshot.value as? NSDictionary != nil {
                
                for user in value! {
                    let contents = user.value as? NSDictionary
                    
                    let uid = contents?.value(forKey: "requesterId") as? String
                    
                    if uid != Auth.auth().currentUser?.uid {
                        let t = contents?.value(forKey: "title")
                        //print(t)
                        self.titles.append(t)
                        
                        let requestUID = contents?.value(forKey: "requestId")
                        self.requestUIDS.append(requestUID)
                        
                        //print(uid)
                        self.uids.append(uid)
                        
                        self.ref.child("USER_ID_DIRECTORY").child(uid as! String).observeSingleEvent(of: .value, with: { (sshot) in
                            let v = sshot.value as? NSDictionary
                            //print(v)
                            
                            let fName = v?.value(forKey: "firstName") as! String
                            let lName = v?.value(forKey: "lastName") as! String
                            let name = "\(fName) \(lName)"
                            
                            self.names.append(name)
                            
                            self.ticketView.reloadData()
                        })
                    }
                    
                }
                self.ticketView.reloadData()
            }
            
        })
        
        
    }
    
    @IBAction func menu_selected(_ sender: Any) {
        print("menu selected")
        if menu_showing {
            leading_constraint.constant = -240
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            leading_constraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        menu_showing = !menu_showing
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "sign_out", sender: self)
        } catch let signOutError as NSError {
            warningLabel.textColor = UIColor.red
            warningLabel.text = signOutError.localizedDescription
            print ("Error signing out: %@", signOutError)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("count: \(names.count)")
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //TicketCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as! ViewFeedRequestCell
        
        print("this is what goes in: names: \(self.names[indexPath.row] as? String) titles: \(self.titles[indexPath.row] as? String)")
        
        cell.nameText.text = self.names[indexPath.row] as? String
        cell.titleText.text = self.titles[indexPath.row] as? String
        
        cell.clipsToBounds = true
        
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        print("selected: \(self.requestUIDS[indexPath.row])")
        
        self.selectedSkill = self.requestUIDS[indexPath.row] as! String
        print("selected skill var: \(self.selectedSkill)")
        
        self.performSegue(withIdentifier: "detail_ticket", sender: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 115.0;//Choose your custom row height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NotHelpedView {
            print("IT IS HAPPENING")
            print("assigning from this: \(self.selectedSkill)")
            vc.uid = self.selectedSkill
        }
        
        if let vc = segue.destination as? SplashScreen {
            self.hidesBottomBarWhenPushed = true
        }
    }

    
}

