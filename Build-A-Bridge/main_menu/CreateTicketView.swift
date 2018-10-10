//
//  CreateTicketView.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 8/2/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class CreateTicketView: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var ticketDetailsMaxLen: UILabel!
    @IBOutlet weak var skillView: UITableView!
    @IBOutlet weak var ticketDate: UILabel!
    @IBOutlet weak var wordsUsed: UILabel!
    @IBOutlet weak var ticketDetails: UITextView!
    @IBOutlet weak var ticketTitle: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    
    var selectedSkill: String = ""
    var selectedContents = NSDictionary()
    var tYear: Int = 0
    var tMonth: Int = 0
    var tDay: Int = 0
    
    var skills = [Any]()
    var skills_uid = [Any]()
    var contents_list = [NSDictionary]()
    
    //var images = [Any]()
    var images = [UIImage]()
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ticketDetailsMaxLen.text = "0/50"
        
        
        // For character count
        self.ticketDetails.delegate = self
        
        navigationController?.isToolbarHidden = false
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.isTranslucent = false
        keyboardToolbar.barTintColor = UIColor.white
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissKeyboard)
        )
        addButton.tintColor = UIColor.black
        keyboardToolbar.items = [addButton]
        ticketTitle.inputAccessoryView = keyboardToolbar
        ticketDetails.inputAccessoryView = keyboardToolbar
        
        navigationItem.title = "Create Request"
        
        let date = Date()
        let calendar = Calendar.current
        
        self.tYear = calendar.component(.year, from: date)
        self.tMonth = calendar.component(.month, from: date)
        self.tDay = calendar.component(.day, from: date)
        
        ticketDate.text = "\(self.tDay)/\(self.tMonth)/\(self.tYear)"
        
        
        var handle:DatabaseHandle
        var skill_contents:String = ""
        
        let profPicStorage = Storage.storage(url:"gs://build-a-bridge-207816.appspot.com")
        

        self.ref.child("SKILLS").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            for skill in value! {
                //print(user)
                let contents = skill.value as? NSDictionary
                let name = contents?.value(forKey: "name")
                let s_uid = contents?.value(forKey: "id")
                //print(t)
                self.skills.append(name)
                self.skills_uid.append(s_uid)
                
                self.contents_list.append(contents!)
                
                let uid = contents?.value(forKey: "id") as! String
                
                print("SKILL UID: \(uid as? String)")
                
                //set image to profilePic of requester
                let volPicRref = profPicStorage.reference().child("SKILL_ICONS/\(uid as! String/* + ".jpeg"*/)")
                volPicRref.getData(maxSize: 15 * 1024 * 1024) { data, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        // Data for "images/island.jpg" is returned
                        let profImage = UIImage(data: data!)
                        self.images.append(profImage as! UIImage)
                        //self.volunteerPicture.image = profImage
                    }
                }
                
            }
            self.skillView.reloadData()
            
        })
    }
    
    func updateCharacterCount() {
        let ticketDetails = self.ticketDetails.text.characters.count
        
        self.ticketDetailsMaxLen.text = "\((0) + ticketDetails)/50"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateCharacterCount()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(textView == ticketDetails){
            return ticketDetails.text.characters.count +  (text.characters.count - range.length) <= 50
        }
        return false
    }

    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func submitRequest(_ sender: Any) {
        //var ref: DatabaseReference!
        
        //ref = Database.database().reference()
        
        if ticketTitle.text != "" && self.ticketDetails.text != "" && self.selectedSkill != nil {
            let subRequest = self.ref.child("REQUESTS").child("STATE").child("NEW_YORK").child("REGION").child("BUFFALO").child("REQUESTED").childByAutoId()
            
            print("request: \(subRequest)")
            
            subRequest.setValue([
                "details": ticketDetails.text,
                "requestId": subRequest.key,
                "requesterId": Auth.auth().currentUser?.uid,
                "skillId": self.selectedSkill,
                "status": "REQUESTED",
                "timestamp": ["day": self.tDay, "month": self.tMonth, "year": self.tYear],
                "title": ticketTitle.text!
                ])
            
            var uid = Auth.auth().currentUser?.uid
            
            let subRequestByUser = self.ref.child("REQUESTS_BY_USER").child((Auth.auth().currentUser?.uid)!).child("REQUESTED").child(subRequest.key)
            subRequestByUser.setValue([
                "details": ticketDetails.text,
                "requestId": subRequest.key,
                "requesterId": Auth.auth().currentUser?.uid,
                "skillId": self.selectedContents.value(forKey: "id") as? String,
                "status": "REQUESTED",
                "timestamp": ["day": self.tDay, "month": self.tMonth, "year": self.tYear],
                "title": ticketTitle.text!,
                ])
            
            //[[String:Any]]()
            
            self.performSegue(withIdentifier: "back_to_feed", sender: self)
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(self.skills.count)")
        return self.skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "skill_cell_ticket_create", for: indexPath) as! CreateTicketSkillSelectCell
    
        if indexPath.row <= self.images.count-1 {
            cell.imageSkill.image = self.images[indexPath.row] as! UIImage
        }
        //cell.imageSkill.image = self.images[indexPath.row] as! UIImage
        
        cell.labelSkill.text = self.skills[indexPath.row] as? String
        
        //cell.clipsToBounds = true
        
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        print("selected: \(self.skills[indexPath.row])")
        self.selectedSkill = self.skills_uid[indexPath.row] as! String
        self.selectedContents = self.contents_list[indexPath.row]
    }
    
}
