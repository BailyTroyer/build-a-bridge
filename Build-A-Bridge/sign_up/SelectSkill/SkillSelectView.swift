import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class SkillSelectView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedSkill: String = ""
    
    var selectedSkills = [Any]()
    
    @IBOutlet weak var skillTableView: UITableView!
    
    var skills = [String]()
    var skill_uids = [String]()
    var images = [UIImage]()
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skillTableView.allowsMultipleSelection = true
        
        let profPicStorage = Storage.storage(url:"gs://build-a-bridge-207816.appspot.com")
        
        
        self.ref.child("SKILLS").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            for skill in value! {
                //print(user)
                let contents = skill.value as? NSDictionary
                let name = contents?.value(forKey: "name")
                let skill_uid = contents?.value(forKey: "id")
                //print(t)
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
            self.skillTableView.reloadData()
            
        })
        
    }
    
    
    
    // UITableViewAutomaticDimension calculates height of label contents/text
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        // Swift 4.1 and below
        return UITableViewAutomaticDimension
    }
    
    @IBAction func `continue`(_ sender: Any) {
        
        let uid = Auth.auth().currentUser!.uid
        
        self.performSegue(withIdentifier: "finish_sign_up", sender: self)
        
        let setSkills = self.ref.child("SKILLS_BY_USER").child(uid)
        
        for skill_uid in self.selectedSkills {
            print("skill: \(skill_uid as? String)")
            setSkills.setValue([
                "\(skill_uid)": "true"
                ])
        }
        
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
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "select_skill_cell", for: indexPath) as! SkillSelectCell
        
        //cell.imageSkill.image = UIImage(named: "panda.jpg")
        if indexPath.row <= self.images.count-1 {
            cell.skillImage.image = self.images[indexPath.row] as UIImage
        }
        //cell.imageSkill.image = self.images[indexPath.row] as! UIImage
        print("images list: \(self.images)")
        print(self.skills[indexPath.row])
        cell.name.text = self.skills[indexPath.row]
        
        print("creating cell")
        
        cell.clipsToBounds = true
        
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.selectedSkills.append(self.skills[indexPath.row])
        self.selectedSkills.append(self.skill_uids[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        for (index, element) in self.selectedSkills.enumerated() {
            print("Item \(index): \(element)")
            if element as! String == self.skills[indexPath.row] {
                self.selectedSkills.remove(at: index)
            }
        }
        
    }
    
}




