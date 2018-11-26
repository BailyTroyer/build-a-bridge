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
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var requestsView: UITableView!
    var ref = Database.database().reference()

    var requests = [request]()
    var selectedRequest: request?
    
    typealias FinishedDownload = () -> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("requests view did appear")
        print("preselected: \(self.segmentControl.selectedSegmentIndex)")
        //self.load_out()
        self.load_out()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.load_data()
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        if let index = self.requestsView.indexPathForSelectedRow{
            self.requestsView.deselectRow(at: index, animated: true)
            print("trying to deselect")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.requests.count
        switch self.segmentControl.selectedSegmentIndex {
        case 0:
            //self.load_out()
            return self.requests.count
        case 1:
            //self.load_in()
            return self.requests.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("-------")
        if indexPath.row <= self.requests.count-1 {
            if self.segmentControl.selectedSegmentIndex == 0 {
                print("selected idx 0")
                if self.requests[indexPath.row].type! == "0" || self.requests[indexPath.row].type! == "2" {
                    print("showing type 0/2")
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as! ViewFeedRequestCell
                    cell.nameText.text = self.requests[indexPath.row].name
                    cell.titleText.text = self.requests[indexPath.row].title
                    return (cell)
                }
            } else if self.segmentControl.selectedSegmentIndex == 1 {
                print("selected idx 1")
                if self.requests[indexPath.row].type == "1" {
                    print("showing type 1")
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as! ViewFeedRequestCell
                    cell.nameText.text = self.requests[indexPath.row].name
                    cell.titleText.text = self.requests[indexPath.row].title
                    return (cell)
                } else {
                    print("doing nothing")
                }
            }
        }
        
        print("-------")
        
        return tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as! ViewFeedRequestCell
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
    
    @IBAction func segmentChanged(_ sender: Any) {
        //print("selected: \(self.segmentControl.selectedSegmentIndex)")
        switch self.segmentControl.selectedSegmentIndex {
        case 0:
            print("callng load out")
            self.load_out()
        case 1:
            self.load_in()
        default:
            break
        }
    }
    
//    func load_data() {
//        self.requests = []
//        self.requestsView.reloadData()
//        let sv = UIViewController.displaySpinner(onView: self.view)
//
//    }
    
    func load_in() {
        self.requests = []
        print("empty requests: \(self.requests)")
        print("=starting load in=")
        let sv = UIViewController.displaySpinner(onView: self.view)
        self.ref.child("REQUESTS_BY_USER").child((Auth.auth().currentUser?.uid)!).child("REQUESTED").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            print("snapshot: \(value)")
            
            if value != nil {
                for r in value! {
                    //print(r)
                    let k = r.key as? String
                    let contents = value?.value(forKey: k!) as? NSDictionary
                    let uid = contents?.value(forKey: "requestId") as! String
                    let name_uid = contents?.value(forKey: "requesterId") as! String
                    let title = contents?.value(forKey: "title") as! String
                    let desc = contents?.value(forKey: "details") as! String
                    
                    //let name = self.get_name(n_uid: name_uid)
                    
                    self.ref.child("USER_ID_DIRECTORY").child(name_uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        let contents = snapshot.value as? NSDictionary
                        
                        let f = (contents?.value(forKey: "firstName") as? String)!
                        let l = (contents?.value(forKey: "lastName") as? String)!
                        
                        let rq = request(uid: uid, type: "1", name: "\(f) \(l)", title: title, desc: desc)
                        self.requests.append(rq)
                        
                        print("TYPE: 1")
                        //self.requestsView.reloadData()
                        UIViewController.removeSpinner(spinner: sv)
                        print("reloading data")
                        print("=ending load=")
                        print("after load: \(self.requests)")
                        self.requestsView.reloadData()
                    })
                }
            } else {
                UIViewController.removeSpinner(spinner: sv)
                print("reloading data")
                print("=ending load=")
                print("after load: \(self.requests)")
                self.requestsView.reloadData()
            }
            //self.requestsView.reloadData()
        })
    }
    
    func load_out() {
        print("=starting load out=")
        self.requests = []
        print("empty requests: \(self.requests)")
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        self.ref.child("REQUESTS_BY_USER").child((Auth.auth().currentUser?.uid)!).child("IN_PROGRESS_VOLUNTEER").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            if value != nil {
                for r in value! {
                    //print(r)
                    let k = r.key as? String
                    let contents = value?.value(forKey: k!) as? NSDictionary
                    let uid = contents?.value(forKey: "requestId") as! String
                    let name_uid = contents?.value(forKey: "volunteerId") as! String
                    let title = contents?.value(forKey: "title") as! String
                    let desc = contents?.value(forKey: "details") as! String
                    
                    //let name = self.get_name(n_uid: name_uid)
                    
                    self.ref.child("USER_ID_DIRECTORY").child(name_uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let contents = snapshot.value as? NSDictionary
                        
                        let f = (contents?.value(forKey: "firstName") as? String)!
                        let l = (contents?.value(forKey: "lastName") as? String)!
                        
                        let rq = request(uid: uid, type: "0", name: "\(f) \(l)", title: title, desc: desc)
                        self.requests.append(rq)
                        
                        print("TYPE: 0")
                        
                        //self.requestsView.reloadData()
                    })
                    
                }
            } else {
                UIViewController.removeSpinner(spinner: sv)
                print("reloading data")
                print("=ending load=")
                print("after load: \(self.requests)")
                self.requestsView.reloadData()
            }
            //self.requestsView.reloadData()
            
            //----------------------------------------------------------------------
            
            self.ref.child("REQUESTS_BY_USER").child((Auth.auth().currentUser?.uid)!).child("IN_PROGRESS_REQUESTER").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                if value != nil {
                    for r in value! {
                        //print(r)
                        let k = r.key as? String
                        let contents = value?.value(forKey: k!) as? NSDictionary
                        let uid = contents?.value(forKey: "requestId") as! String
                        let name_uid = contents?.value(forKey: "requesterId") as! String
                        let title = contents?.value(forKey: "title") as! String
                        let desc = contents?.value(forKey: "details") as! String
                        
                        //let name = self.get_name(n_uid: name_uid)
                        
                        self.ref.child("USER_ID_DIRECTORY").child(name_uid).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            let contents = snapshot.value as? NSDictionary
                            
                            let f = (contents?.value(forKey: "firstName") as? String)!
                            let l = (contents?.value(forKey: "lastName") as? String)!
                            
                            let rq = request(uid: uid, type: "2", name: "\(f) \(l)", title: title, desc: desc)
                            self.requests.append(rq)
                            
                            print("TYPE: 2")
                            
                            //self.requestsView.reloadData()
                            UIViewController.removeSpinner(spinner: sv)
                            print("=ending load=")
                            print("after load: \(self.requests)")
                            self.requestsView.reloadData()
                        })
                        
                    }
                }
                
                //self.requestsView.reloadData()
            })
            
        })
        
    }
    
}
