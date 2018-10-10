//
//  ListContactView.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 9/5/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class ListContactView: UITableViewController {
    
    var ref = Database.database().reference()

    var uids = [Any]()
    var selectedContact: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("uid: \(Auth.auth().currentUser?.uid as! String)")
        self.ref.child("MESSAGES_BY_USER").child(Auth.auth().currentUser?.uid as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            print("messages value: \(String(describing: value))")
            
            if snapshot.value as? NSDictionary != nil {
                
                for user in value! {
                    print("user: \(user)")
                    self.uids.append(user.key as! String)
                    
                    
                    
                    self.tableView.reloadData()
//                    let contents = user.value as? NSDictionary
//
//                    let uid = contents?.value(forKey: "requesterId") as? String
//
//                    if uid != Auth.auth().currentUser?.uid {
//                        let t = contents?.value(forKey: "title")
//                        //print(t)
//                        self.titles.append(t)
//
//                        let requestUID = contents?.value(forKey: "requestId")
//                        self.requestUIDS.append(requestUID)
//
//                        //print(uid)
//                        self.uids.append(uid)
//
//                        self.ref.child("USER_ID_DIRECTORY").child(uid as! String).observeSingleEvent(of: .value, with: { (sshot) in
//                            let v = sshot.value as? NSDictionary
//                            //print(v)
//
//                            let fName = v?.value(forKey: "firstName") as! String
//                            let lName = v?.value(forKey: "lastName") as! String
//                            let name = "\(fName) \(lName)"
//
//                            self.names.append(name)
//
//                            self.ticketView.reloadData()
//                        })
//                    }
                    
                }
                self.tableView.reloadData()
//                self.ticketView.reloadData()
            }
            
        })
        
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(self.uids.count)")
        return self.uids.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        print("creating cell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell

        cell.contactName.text = "name"
        cell.contactImage.image = #imageLiteral(resourceName: "default_profile")
        cell.lastMessageTime.text = ""
        cell.lastMessageContent.text = ""

        cell.clipsToBounds = true

        return (cell)
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        //print("selected: \(self.requestUIDS[indexPath.row])")
        
        //self.selectedSkill = self.requestUIDS[indexPath.row] as! String
        //print("selected skill var: \(self.selectedSkill)")
        
        //self.performSegue(withIdentifier: "detail_ticket", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 115.0;//Choose your custom row height
    }

    
}
