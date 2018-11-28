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
import UIEmptyState

struct contact {
    var message_uid:String?
    var name:String?
    var image:UIImage
    var time:String?
    var user_uid:String?
}

class ListContactView: UITableViewController {

    var ref = Database.database().reference()

    var uids = [Any]()
    var message_uids = [Any]()
    var selectedContact: String = ""
    var contacts = [contact]()

    var selected_contact = [contact]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.load_data()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MessageView {
            vc.message_id = self.selected_contact[0].message_uid!
            vc.reciever_id = self.selected_contact[0].user_uid!
            
            print("message-id prepare: \(vc.message_id)")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(self.uids.count)")
        return self.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row <= self.contacts.count-1 {

            print("creating cell")

            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell

            print("size of contacts: \(self.contacts.count)")
            print("idxpth: \(indexPath.row)")

            //index out of range
            
            let cntct = self.contacts[indexPath.row]

            cell.contactName.text = cntct.name

            if cntct.image == nil {
                cell.contactImage.image = #imageLiteral(resourceName: "default_profile")

            } else {
                cell.contactImage.image = #imageLiteral(resourceName: "default_profile")
            }

            cell.lastMessageTime.text = cntct.time
            cell.lastMessageContent.text = ""

            cell.clipsToBounds = true

            return (cell)
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        }
    }

    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        print("SELECTED THIS CONTACT: \(self.contacts[indexPath.row])")
        self.selected_contact.append(self.contacts[indexPath.row])
        self.performSegue(withIdentifier: "to_message", sender: self)
    }

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 115.0;//Choose your custom row height
//    }

    
    func load_data() {
        
        self.contacts = []
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        print("loading data")
        
        let uid = (Auth.auth().currentUser?.uid)!
        
        print("UID: \(uid)")
        
        self.ref.child("MESSAGES_BY_USER").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            print("messages value: \(value)")
            
            if snapshot.value as? NSDictionary != nil {
                
                for user in value! {
                    print("user: \(user)")
                    
                    let user_uid = user.key as! String
                    let message_uid = user.value as! String
                    
                    print("message_uid: \(message_uid)")
                    
                    self.uids.append(user.key as! String)
                    self.message_uids.append(user.value as! String)
                    
                    
                    self.ref.child("MESSAGES").child(message_uid).observeSingleEvent(of: .value, with: { (ssnapshot) in
                        
                        print("message_detail value: \(ssnapshot)")
                        
                        if ssnapshot.value as? NSDictionary != nil {
                            let data = ssnapshot.value as? NSDictionary
                            
                            print("DATA: \(String(describing: data))")
                            
                            let time = data!.value(forKey: "lastUpdated") as! NSDictionary
                            
                            print("time: \(String(describing: time))")
                            
                            let hour = time.value(forKey: "hour") as! integer_t
                            let minute = time.value(forKey: "minute") as! integer_t
                            
                            let time_stamp = String(hour) + ":" + String(minute)
                            
                            
                            self.ref.child("USER_ID_DIRECTORY").child(user_uid).observeSingleEvent(of: .value, with: { (s) in
                                if s.value as? NSDictionary != nil {
                                    print("USER: \(String(describing: s.value as? NSDictionary))")
                                    
                                    let fname = (s.value as? NSDictionary)?.value(forKey: "firstName") as! String
                                    let lname = (s.value as? NSDictionary)?.value(forKey: "lastName") as! String
                                    
                                    let whole_name = "\(fname) \(lname)"
                                    
                                    let img = #imageLiteral(resourceName: "portrait_2")
                                    
                                    self.contacts.append(contact(message_uid: message_uid, name: whole_name, image: img, time: time_stamp, user_uid: user_uid))
                                    
                                    print("adding to contacts")
                                    
                                    //self.tableView.reloadData()
                                    
                                }
                                self.tableView.reloadData()
                                print("contacts1: \(self.contacts)")
                                UIViewController.removeSpinner(spinner: sv)
                            })
                            
                        }
                    })
                }
            } else {
                print("no contacts")
                UIViewController.removeSpinner(spinner: sv)
            }
//            self.tableView.reloadData()
//            print("contacts: \(self.contacts)")
//            UIViewController.removeSpinner(spinner: sv)
        })
    }

}