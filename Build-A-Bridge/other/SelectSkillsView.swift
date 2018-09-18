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

class SelectSkillsView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var skillView: UITableView!
    var selectedSkill: String = ""
    
    var skills = [Any]()
    //var images = [Any]()
    var images = [UIImage]()
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var handle:DatabaseHandle
        var skill_contents:String = ""
        
        let profPicStorage = Storage.storage(url:"gs://build-a-bridge-207816.appspot.com")
        
        
        self.ref.child("SKILLS").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            for skill in value! {
                //print(user)
                let contents = skill.value as? NSDictionary
                let name = contents?.value(forKey: "name")
                //print(t)
                self.skills.append(name)
                
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
    
    /*@IBAction func submitRequest(_ sender: Any) {
        //var ref: DatabaseReference!
        
        //ref = Database.database().reference()
        
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
        
        //[[String:Any]]()
        
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("count: \(self.skills.count)")
        return self.skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //skill_cell_ticket_create
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "skill_cell_ticket_create", for: indexPath) as! CreateTicketSkillSelectCell
        
        //cell.imageSkill.image = UIImage(named: "panda.jpg")
        if indexPath.row <= self.images.count-1 {
            cell.imageSkill.image = self.images[indexPath.row] as! UIImage
        }
        //cell.imageSkill.image = self.images[indexPath.row] as! UIImage
        print("images list: \(self.images)")
        cell.labelSkill.text = self.skills[indexPath.row] as? String
        
        print("creating cell")
        
        cell.clipsToBounds = true
        
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        print("selected: \(self.skills[indexPath.row])")
        self.selectedSkill = self.skills[indexPath.row] as! String
    }
    
}
