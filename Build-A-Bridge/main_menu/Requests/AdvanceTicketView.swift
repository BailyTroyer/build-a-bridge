import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class AdvanceTicketView: UIViewController {
    
    @IBOutlet weak var requesterPicture: UIImageView!
    @IBOutlet weak var volunteerPicture: UIImageView!
    @IBOutlet weak var requesterName: UILabel!
    @IBOutlet weak var volunteerName: UILabel!
    @IBOutlet weak var ticketDescription: UILabel!
    
    var uid = String()
    var ref = Database.database().reference()
    
    var requesterUID = String()
    var volunteerUID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let profPicStorage = Storage.storage(url:"gs://build-a-bridge-207816.appspot.com")
        print("UID SENT: \(uid)")
        
        self.ref.child("REQUESTS").child("STATE").child("NEW_YORK").child("REGION").child("BUFFALO").child("IN_PROGRESS").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
        
            let contents = snapshot.value as? NSDictionary
            let t = contents?.value(forKey: "title")
            let description = contents?.value(forKey: "details")
            
            self.requesterUID = contents?.value(forKey: "requesterId") as! String
            self.volunteerUID = contents?.value(forKey: "volunteerId") as! String
            
            self.ref.child("USER_ID_DIRECTORY").child(self.requesterUID).observeSingleEvent(of: .value, with: { (sshot) in
                
                let cnts = sshot.value as? NSDictionary
                
                let reqFname = cnts?.value(forKey: "firstName") as! String
                
                var name = "\(reqFname)"
                
                
                let reqPicRref = profPicStorage.reference().child("PROFILE_PICTURES/\(self.requesterUID)")
                reqPicRref.getData(maxSize: 15 * 1024 * 1024) { data, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        // Data for "images/island.jpg" is returned
                        let profImage = UIImage(data: data!)
                        self.requesterPicture.image = profImage
                        self.requesterPicture.layer.cornerRadius = self.requesterPicture.frame.height/2
                        self.requesterPicture.layer.masksToBounds = true
                    }
                }
                
                self.requesterName.text = name
                
            })
            
            self.ref.child("USER_ID_DIRECTORY").child(self.volunteerUID).observeSingleEvent(of: .value, with: { (sshot) in
                
                let cnts = sshot.value as? NSDictionary
                
                let reqFname = cnts?.value(forKey: "firstName") as! String
                
                var name = "\(reqFname)"
                
                let volPicRref = profPicStorage.reference().child("PROFILE_PICTURES/\(self.volunteerUID)")
                volPicRref.getData(maxSize: 15 * 1024 * 1024) { data, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        // Data for "images/island.jpg" is returned
                        let profImage = UIImage(data: data!)
                        self.volunteerPicture.image = profImage
                        self.volunteerPicture.layer.cornerRadius = self.volunteerPicture.frame.height/2
                        self.volunteerPicture.layer.masksToBounds = true
                        
                    }
                }
                
                self.volunteerName.text = name
            })
            
            
            self.ticketDescription.text = description as! String
            self.title = t as! String
            //self.navigationItem.title = @"The title";
            //print(v)
        })
    }
    
    @IBAction func message(_ sender: Any) {
    
    }
    @IBAction func cancel(_ sender: Any) {
        
    }
    
}
