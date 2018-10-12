//
//  HomeView.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 7/18/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

struct request {
    var uid:String?
    var type:String?
    var name:String?
    var title:String?
    var desc:String?
}

class RequestsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var requestsView: UITableView!
    var ref = Database.database().reference()

    var requests = [request]()
    var selectedRequest: request?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref.child("REQUESTS_BY_USER").child((Auth.auth().currentUser?.uid)!).child("IN_PROGRESS_VOLUNTEER").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            if value != nil {
                for r in value! {
                    print(r)
                    let k = r.key as? String
                    let contents = value?.value(forKey: k!) as? NSDictionary
                    let uid = contents?.value(forKey: "requestId") as! String
                    let name_uid = contents?.value(forKey: "volunteerId") as! String
                    let title = contents?.value(forKey: "title") as! String
                    let desc = contents?.value(forKey: "details") as! String
                    
                    //let name = self.get_name(n_uid: name_uid)
                    
                    self.ref.child("USER_ID_DIRECTORY").child(name_uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let contents = snapshot.value as? NSDictionary
                        
                        var f = (contents?.value(forKey: "firstName") as? String)!
                        var l = (contents?.value(forKey: "lastName") as? String)!
                        
                        let rq = request(uid: uid, type: "0", name: "\(f) \(l)", title: title, desc: desc)
                        self.requests.append(rq)
                        
                        self.requestsView.reloadData()
                    })
                    
                }
            }
        
            self.requestsView.reloadData()
        })
        
        
        self.ref.child("REQUESTS_BY_USER").child((Auth.auth().currentUser?.uid)!).child("REQUESTED").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            if value != nil {
                for r in value! {
                    print(r)
                    let k = r.key as? String
                    let contents = value?.value(forKey: k!) as? NSDictionary
                    let uid = contents?.value(forKey: "requestId") as! String
                    let name_uid = contents?.value(forKey: "requesterId") as! String
                    let title = contents?.value(forKey: "title") as! String
                    let desc = contents?.value(forKey: "details") as! String
                    
                    //let name = self.get_name(n_uid: name_uid)
                    
                    self.ref.child("USER_ID_DIRECTORY").child(name_uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let contents = snapshot.value as? NSDictionary
                        
                        var f = (contents?.value(forKey: "firstName") as? String)!
                        var l = (contents?.value(forKey: "lastName") as? String)!
                        
                        let rq = request(uid: uid, type: "1", name: "\(f) \(l)", title: title, desc: desc)
                        self.requests.append(rq)
                        
                        self.requestsView.reloadData()
                    })
                
                }
            }
            
            self.requestsView.reloadData()
        })
        
    
        self.ref.child("REQUESTS_BY_USER").child((Auth.auth().currentUser?.uid)!).child("IN_PROGRESS_REQUESTER").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            if value != nil {
                for r in value! {
                    print(r)
                    let k = r.key as? String
                    let contents = value?.value(forKey: k!) as? NSDictionary
                    let uid = contents?.value(forKey: "requestId") as! String
                    let name_uid = contents?.value(forKey: "requesterId") as! String
                    let title = contents?.value(forKey: "title") as! String
                    let desc = contents?.value(forKey: "details") as! String
                    
                    //let name = self.get_name(n_uid: name_uid)
                    
                    self.ref.child("USER_ID_DIRECTORY").child(name_uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let contents = snapshot.value as? NSDictionary
                        
                        var f = (contents?.value(forKey: "firstName") as? String)!
                        var l = (contents?.value(forKey: "lastName") as? String)!
                        
                        let rq = request(uid: uid, type: "2", name: "\(f) \(l)", title: title, desc: desc)
                        self.requests.append(rq)
                        
                        self.requestsView.reloadData()
                    })
                    
                }
            }
            
            self.requestsView.reloadData()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.isNavigationBarHidden = true
        if let index = self.requestsView.indexPathForSelectedRow{
            self.requestsView.deselectRow(at: index, animated: true)
            print("trying to deselect")
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.requests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as! ViewFeedRequestCell
        
        //ERROR HERE
        //print("this is what goes in: names: \(self.names[indexPath.row] as? String) titles: \(self.titles[indexPath.row] as? String)")

        //INDEX OUT OF RANGE HERE
        
        if indexPath.row <= self.requests.count-1 {
            cell.nameText.text = self.requests[indexPath.row].name
        }
        
        if indexPath.row <= self.requests.count-1 {
            cell.titleText.text = self.requests[indexPath.row].title
        }
        
        return (cell)
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        let selected = self.requests[indexPath.row]
        self.selectedRequest = selected
        
        if selected.type == "1"/* || selected.type == "2" */{
            //Not Helped Request View
            self.performSegue(withIdentifier: "to_not", sender: self)
        } else {
            // other
            self.performSegue(withIdentifier: "to_advanced", sender: self)
        }
        print("selected: \(selected)")
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115.0;//Choose your custom row height
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? AdvanceTicketView {
            
            print("uid to send: \(self.selectedRequest?.uid as? String)")
            
            vc.uid = (self.selectedRequest?.uid)!
        }
        
        if let vc = segue.destination as? NotHelpedRequestView {
            vc.u_Name = (self.selectedRequest?.name)!
            vc.u_Desc = (self.selectedRequest?.desc)!
            vc.u_Title = (self.selectedRequest?.title)!
            vc.u_Uid = (self.selectedRequest?.uid)!
        }
        
    }
    
}
