import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class NotHelpedRequestView: UIViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var uName: UILabel!
    @IBOutlet weak var uDesc: UILabel!
    
    var u_Name = String()
    var u_Desc = String()
    var u_Uid = String()
    var u_Title = String()
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.u_Title
        self.uName.text = self.u_Name
        self.uDesc.text = self.u_Desc
        
        let profPicStorage = Storage.storage(url:"gs://build-a-bridge-207816.appspot.com")
        
        let picRref = profPicStorage.reference().child("PROFILE_PICTURES/\((Auth.auth().currentUser?.uid)! + ".jpeg")")
        
        
        picRref.getData(maxSize: 15 * 1024 * 1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                // Data for "images/island.jpg" is returned
                let profImage = UIImage(data: data!)
                self.profilePic.image = profImage
            }
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        print("cancel")
        
        let subRequest = self.ref.child("REQUESTS").child("STATE").child("New York").child("REGION").child("Buffalo").child("REQUESTED").child(self.u_Uid).removeValue()
        
        print("request test: \(subRequest)")
        
        let subRequestByUser = self.ref.child("REQUESTS_BY_USER").child((Auth.auth().currentUser?.uid)!).child("REQUESTED").child(self.u_Uid).removeValue()
        
        _ = navigationController?.popViewController(animated: true)
        
    }
}
