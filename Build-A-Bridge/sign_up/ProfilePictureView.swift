//
//  ProfilePictureViewViewController.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 7/29/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class ProfilePictureView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
        profilePicture.addGestureRecognizer(tapGesture)
        profilePicture.isUserInteractionEnabled = true
        
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.layer.masksToBounds = true
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            //image tapped
            
            print("image tapped")
            
            let image = UIImagePickerController()
            image.delegate = self
            // can also select camera
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            //can change to true if needed
            image.allowsEditing = false
            self.present(image, animated: true, completion: nil)
            //self.present(image, animated: true) {
             //after complete
            //print("image selected")
            // }
        }
    }
    
    //------------------------------image logic
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            profilePicture.image = image
            let userUid = Auth.auth().currentUser?.uid
            
            let profPicStorage = Storage.storage(url:"gs://build-a-bridge-207816.appspot.com")
            let storageRef = profPicStorage.reference()
            
            
            // Create a reference to the file you want to upload
            let uploadPic = storageRef.child("PROFILE_PICTURES").child(userUid! + ".jpeg")
            
            var data = NSData()
            data = image.jpegData(compressionQuality: 0.8)! as NSData
            // set upload path
            let filePath = "\(Auth.auth().currentUser!.uid)/\("userPhoto")"
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let upTask = uploadPic.putData(data as Data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print("error")
                    print(error.localizedDescription)
                    return
                }
            }
        } else {
            //ERROR
            print("ERROR")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //------------------------------image logic

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
