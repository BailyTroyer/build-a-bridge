//
//  File.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 8/20/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

struct name_id {
    var name:String?
    var id:String?
    var desc:String?
}

class SkillView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var skillView: UITableView!
    var skills = [String]()
    var images = [UIImage]()
    var ref = Database.database().reference()
    
    var skills_structs = [name_id]()
    
    var selectedSkills = [Any]()
    
    var current_selected_name: String = ""
    var current_selected_desc: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        skillView.allowsMultipleSelection = true
        
        let profPicStorage = Storage.storage(url:"gs://build-a-bridge-207816.appspot.com")
        
        self.ref.child("SKILLS_BY_USER").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            //value -> kv pairs of k=uid v=true
            
            let value = snapshot.value as? NSDictionary
            
            print("user skills: \(String(describing: value))")
            
            if value != nil {
                for skill in value! {
                    let skill_id = skill.key as! String
                    self.ref.child("SKILLS").child(skill_id).observeSingleEvent(of: .value, with: { (ssnapshot) in
                    
                        //let n = ssnapshot.value(forKey: "name") as? String
                        
                        let v = ssnapshot.value as! NSDictionary
                        
                        print("value \(v)")
                        let n = v.value(forKey: "name") as? String
                        let d = v.value(forKey: "description") as? String
                        //print("NAME \(n)")
                        let pair = name_id(name: n, id: skill_id, desc: d)
                        //let pair = name_id(name: "name", id: "123")
                        self.skills_structs.append(pair)

                        print("PATH:")
                        print("Assets.xcassets/\(skill_id)")
                        let profImage = UIImage(named: skill_id as! String)
                        print("appending image")
                        self.images.append(profImage ?? #imageLiteral(resourceName: "skills_general"))
                        self.skillView.reloadData()
                    })
                }
            }
            self.skillView.reloadData()
        })
        
        //self.skillView.reloadData()
    }
    
    
    @IBAction func edit(_ sender: Any) {
        print("selected: \(self.selectedSkills)")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.skills_structs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "skill_cell", for: indexPath) as! SkillCell
        
        if indexPath.row <= self.images.count-1 {
            print("selecting IMAGE")
            cell.skillImage.image = self.images[indexPath.row]
        }
        //cell.imageSkill.image = self.images[indexPath.row] as! UIImage
        //print("images list: \(self.images)")
        
        if indexPath.row <= self.skills_structs.count-1 {
            //cell.skillName.text = self.skills[indexPath.row]
            print("name of cell: \(String(describing: self.skills_structs[indexPath.row].name))")
            cell.skillName.text = self.skills_structs[indexPath.row].name
        }
        
        //cell.skillName.text = self.skills[indexPath.row]
        
        print("creating cell")
        
        cell.clipsToBounds = true
        
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("indexPath.row: \(indexPath.row)")
        print("skills count: \(self.skills_structs.count-1)")
        
        if indexPath.row <= self.skills_structs.count-1 {
            
            self.selectedSkills.append(self.skills_structs[indexPath.row])
            
            self.current_selected_desc = self.skills_structs[indexPath.row].desc as! String
            self.current_selected_name = self.skills_structs[indexPath.row].name as! String
            
            
            print("SELECTED DESC: \(self.current_selected_desc)")
            
            self.performSegue(withIdentifier: "pop_over", sender: self)
            
            self.skillView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        for (index, element) in self.selectedSkills.enumerated() {
            print("Item \(index): \(element)")
            if element as! String == self.skills[indexPath.row] {
                self.selectedSkills.remove(at: index)
                self.skillView.reloadData()
            }
        }
    
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            //index out of range
            //self.skills.remove(at: indexPath.row)
            
            print("removing skill: \(self.skills_structs[indexPath.row])")
            
            //let subRequest = self.ref.child("SKILLS_BY_USER").child((Auth.auth().currentUser?.uid)!).child(self.skills_structs[indexPath.row].id!)
            
            let subRequest = self.ref.child("SKILLS_BY_USER").child((Auth.auth().currentUser?.uid)!).child(self.skills_structs[indexPath.row].id as! String).removeValue()
            
//            print("request: \(subRequest)")
//
//            for skill in self.skills_structs {
//                print("setting value")
//                subRequest.setValue([
//                    "\(skill.id)": "true"
//                    ])
//            }
            
            self.skills_structs.remove(at: indexPath.row)
            //self.selectedSkills.remove(at: indexPath.row)
            self.skillView.deleteRows(at: [indexPath], with: .automatic)
        }
        action.image = #imageLiteral(resourceName: "exit")
        action.backgroundColor = .red
        
        return action
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PopUpView {
            vc.name = self.current_selected_name
            vc.desc = self.current_selected_desc
        }
    }
    
    
}
