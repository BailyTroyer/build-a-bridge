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

struct sk_name_id {
    var name:String?
    var id:String?
}

class AddSkillView: UITableViewController {
    
    var selectedSkill: String = ""
    
    var selectedSkills = [Any]()
    
    var skills_structs = [sk_name_id]()
    
    var skills = [String]()
    var skill_uids = [String]()
    var images = [UIImage]()
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsMultipleSelection = true
        //skillTableView.allowsMultipleSelection = true
        
        let profPicStorage = Storage.storage(url:"gs://build-a-bridge-207816.appspot.com")
        
        
        self.ref.child("SKILLS_BY_USER").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            //value -> kv pairs of k=uid v=true
            
            let value = snapshot.value as? NSDictionary
            for skill in value! {
                let skill_id = skill.key as? String
                self.ref.child("SKILLS").child(skill_id!).observeSingleEvent(of: .value, with: { (ssnapshot) in
                    
                    //let n = ssnapshot.value(forKey: "name") as? String
                    
                    let v = ssnapshot.value as! NSDictionary
                    
                    print("value \(v)")
                    let n = v.value(forKey: "name") as? String
                    print("NAME \(n)")
                    let pair = sk_name_id(name: n, id: skill_id)
                    //let pair = name_id(name: "name", id: "123")
                    self.skills_structs.append(pair)
                    }
                )}
            
        })
        
        
        
        self.ref.child("SKILLS").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            for skill in value! {
                //print(user)
                let contents = skill.value as? NSDictionary
                let name = contents?.value(forKey: "name")
                let skill_uid = contents?.value(forKey: "id")

                let sfound = self.skills_structs.contains{ $0.id == skill_uid as? String}
                
                print("SFOUND: \(sfound)")
                
                if !sfound {
                    self.skills.append(name as! String)
                    self.skill_uids.append(skill_uid as! String)
                    
                    let uid = contents?.value(forKey: "id") as! String
                    
                    //print("SKILL UID: \(uid as? String)")
                    
                    //set image to profilePic of requester
                    let volPicRref = profPicStorage.reference().child("SKILL_ICONS/\(uid)")
                    volPicRref.getData(maxSize: 15 * 1024 * 1024) { data, error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            // Data for "images/island.jpg" is returned
                            let profImage = UIImage(data: data!)
                            self.images.append(profImage!)
                            //self.volunteerPicture.image = profImage
                        }
                    }
                }
                
            }
            self.tableView.reloadData()
            
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("count: \(self.skills.count)")
        return self.skills.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddSkillCell", for: indexPath) as! AddSkillCell
        
        //cell.imageSkill.image = UIImage(named: "panda.jpg")
        if indexPath.row <= self.images.count-1 {
           cell.skillViewImage.image = self.images[indexPath.row] as UIImage
        }
        //cell.imageSkill.image = self.images[indexPath.row] as! UIImage
        print("images list: \(self.images)")
        print(self.skills[indexPath.row])
        cell.skillViewLabel.text = self.skills[indexPath.row]
        
        print("creating cell")
        
        cell.clipsToBounds = true
        
        return (cell)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.selectedSkills.append(self.skills[indexPath.row])
        self.selectedSkills.append(self.skill_uids[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        for (index, element) in self.selectedSkills.enumerated() {
            print("Item \(index): \(element)")
            if element as! String == self.skills[indexPath.row] {
                self.selectedSkills.remove(at: index)
            }
        }
        
    }
    
    
    @IBAction func done(_ sender: Any) {
        
        let uid = Auth.auth().currentUser!.uid
        
        for skill_uid in self.selectedSkills {
            print("skill: \(skill_uid as? String)")
            
            let setSkills = self.ref.child("SKILLS_BY_USER").child(uid).child("\(skill_uid)")
            setSkills.setValue("true")
            //setSkills.setValue([
            //    "\(skill_uid)": "true"
            //    ])
        }
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
}

