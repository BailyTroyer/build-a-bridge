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
        //Create the message part in DATABSE AND GO TO TABLE VIEW
        //MAKE TABLE VIEW LOAD MESSAGES
        //IF USER already set up messages, this should route to message view in messages vc
        
        //STEPS:
        
        //check if exists, otherwise create:
        //MESSAGES_BY_USER -> CURRENT_USER -> k:OTHER_USER, v:message_uid
        //MESSAGES_BY_USER -> OTHER_USER -> k:CURRENT_USER, v:message_uid
        
        //print("THIS IS MESSAGES FOR USER: \(self.ref.child("MESSAGES_BY_USER").child(self.volunteerUID))")
        
        let m_uid = self.ref.childByAutoId().key
        print("muid: \(m_uid)")
        
        self.ref.child("MESSAGES_BY_USER").child(self.volunteerUID).observeSingleEvent(of: .value, with: { (sshot) in

            //print("pre-contents: \(String(describing: sshot.value as? NSMutableDictionary))")

            if sshot.value as? NSMutableDictionary == nil {


                self.ref.child("MESSAGES").childByAutoId().setValue([
                    "msgId": "\(m_uid)",
                    "uid1": "\(self.volunteerUID)",
                    "uid2": "\(self.requesterUID)"
                ])

                self.ref.child("MESSAGES_BY_USER").child(self.volunteerUID).setValue([
                    "\(self.requesterUID)": "\(m_uid)"
                ])
            } else {
                // forward to vc with messages w/ user
                print("forward to message UI")
            }
        })

        self.ref.child("MESSAGES_BY_USER").child(self.requesterUID).observeSingleEvent(of: .value, with: { (sshot) in

            //print("pre-contents: \(String(describing: sshot.value as? NSMutableDictionary))")

            if sshot.value as? NSMutableDictionary == nil {

                self.ref.child("MESSAGES_BY_USER").child(self.requesterUID).setValue([
                    "\(self.volunteerUID)": "\(m_uid)"
                ])
            } else {
                print("forward to message UI")
            }
        })
        

    }
    
    @IBAction func done(_ sender: Any) {
        complete()
    }
    
    @IBAction func report(_ sender: Any) {
        print("reporting...")
    }
    
    @IBAction func cancel(_ sender: Any) {
        complete()
    }
    
    
    func complete() {
        
        print("UID TO LOOK FOR: \(self.uid)")
        
        self.ref.child("REQUESTS").child("STATE").child("NEW_YORK").child("REGION").child("BUFFALO").child("IN_PROGRESS").child(self.uid).observeSingleEvent(of: .value, with: { (sshot) in

            print("pre-contents: \(sshot.value as? NSMutableDictionary)")

            if let contents = sshot.value as? NSMutableDictionary {
                print("cnts: \(contents)")

                let setStatus = self.ref.child("REQUESTS").child("STATE").child("NEW_YORK").child("REGION").child("BUFFALO").child("COMPLETED").child(self.uid)
                print("change db: \(setStatus)")

                setStatus.setValue(contents)

                setStatus.child("volunteerId").setValue(Auth.auth().currentUser?.uid)


                self.ref.child("REQUESTS").child("STATE").child("NEW_YORK").child("REGION").child("BUFFALO").child("IN_PROGRESS").child(self.uid).removeValue()
            }

        })


        self.ref.child("REQUESTS_BY_USER").child(self.requesterUID).child("IN_PROGRESS_REQUESTER").child(self.uid).removeValue()
        self.ref.child("REQUESTS_BY_USER").child(self.volunteerUID).child("IN_PROGRESS_VOLUNTEER").child(self.uid).removeValue()
        
        
    }
}
