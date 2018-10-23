import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class NotHelpedView: UIViewController {
    
    @IBOutlet weak var rImage: UIImageView!
    @IBOutlet weak var rName: UILabel!
    @IBOutlet weak var rDescription: UILabel!
    
    @IBOutlet weak var sImage: UIImageView!
    @IBOutlet weak var sName: UILabel!
    
    var ref = Database.database().reference()
    var uid = String()
    var requesterUID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let profPicStorage = Storage.storage(url:"gs://build-a-bridge-207816.appspot.com")
        print("UID SENT NOT HELPED VIEW: \(uid)")
        
        self.ref.child("REQUESTS").child("STATE").child("NEW_YORK").child("REGION").child("BUFFALO").child("REQUESTED").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let contents = snapshot.value as? NSDictionary
            
            print("contents: \(String(describing: contents))")
            
            let t = contents?.value(forKey: "title")
            let description = contents?.value(forKey: "details")
            let skill_id = contents?.value(forKey: "skillId")
            
            self.requesterUID = contents?.value(forKey: "requesterId") as! String
            //self.volunteerUID = contents?.value(forKey: "volunteerId") as! String
            
            self.ref.child("USER_ID_DIRECTORY").child(self.requesterUID).observeSingleEvent(of: .value, with: { (sshot) in
                
                let cnts = sshot.value as? NSDictionary
                let reqFname = cnts?.value(forKey: "firstName") as! String
                let reqLname = cnts?.value(forKey: "lastName") as! String
                
                let name = "\(reqFname) \(reqLname)"
                print("requester name: \(name)")
                
                self.rName.text = name 
                
                let reqPicRref = profPicStorage.reference().child("PROFILE_PICTURES/\(self.requesterUID)")
                reqPicRref.getData(maxSize: 15 * 1024 * 1024) { data, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        // Data for "images/island.jpg" is returned
                        let profImage = UIImage(data: data!)
                        self.rImage.image = profImage
                        self.rImage.layer.cornerRadius = self.rImage.frame.height/2
                        self.rImage.layer.masksToBounds = true
                    }
                }
                
            })
            
            self.ref.child("SKILLS").child((skill_id as? String)!).observeSingleEvent(of: .value, with: { (sshot) in
                let cnts = sshot.value as? NSDictionary
                let name = cnts?.value(forKey: "name") as? String
                
                print("assiginging skill name \(String(describing: name))")
                self.sName.text = name
            })
            
            
            self.rDescription.text = description as? String
            self.navigationItem.title = t as? String
        })
    }
    
    @IBAction func help(_ sender: Any) {
        
        print("UID TO LOOK FOR: \(self.uid)")
        
        self.ref.child("REQUESTS").child("STATE").child("NEW_YORK").child("REGION").child("BUFFALO").child("REQUESTED").child(self.uid).observeSingleEvent(of: .value, with: { (sshot) in
            
            print("pre-contents: \(String(describing: sshot.value as? NSMutableDictionary))")
            
            if let contents = sshot.value as? NSMutableDictionary {
                print("cnts: \(contents)")
                
                let setStatus = self.ref.child("REQUESTS").child("STATE").child("NEW_YORK").child("REGION").child("BUFFALO").child("IN_PROGRESS").child(self.uid)
                print("change db: \(setStatus)")
                
                setStatus.setValue(contents)
                
                setStatus.child("volunteerId").setValue(Auth.auth().currentUser?.uid)

                
                self.ref.child("REQUESTS").child("STATE").child("NEW_YORK").child("REGION").child("BUFFALO").child("REQUESTED").child(self.uid).removeValue()
            }
            
        })
        
        
        self.ref.child("REQUESTS_BY_USER").child(self.requesterUID).child("REQUESTED").child(self.uid).observeSingleEvent(of: .value, with: { (sshot) in
            
            if let contents = sshot.value as? NSMutableDictionary {
                print("cnts: \(contents)")
                
                let setStatus = self.ref.child("REQUESTS_BY_USER").child(self.requesterUID).child("IN_PROGRESS_REQUESTER").child(self.uid)
                
                setStatus.setValue(contents)
                
                setStatus.child("volunteerId").setValue(Auth.auth().currentUser?.uid)
                
                let setStatusV = self.ref.child("REQUESTS_BY_USER").child((Auth.auth().currentUser?.uid)!).child("IN_PROGRESS_VOLUNTEER").child(self.uid)
                
                setStatusV.setValue(contents)
                
                setStatusV.child("volunteerId").setValue(Auth.auth().currentUser?.uid)
                
                self.ref.child("REQUESTS_BY_USER").child(self.requesterUID).child("REQUESTED").child(self.uid).removeValue()
            }
        })
        
        
//        self.performSegue(withIdentifier: "back_to_main", sender: self)
    }
    
    
}
