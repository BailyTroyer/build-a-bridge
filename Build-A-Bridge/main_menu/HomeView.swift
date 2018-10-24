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
import FirebaseStorage
import UIEmptyState

struct ticket {
    var title:String
    var name:String
    //var details:String
}

class HomeView: UIViewController, UITableViewDelegate, UITableViewDataSource, UIEmptyStateDataSource, UIEmptyStateDelegate {
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var leading_constraint: NSLayoutConstraint!
    @IBOutlet weak var slide_view: UIView!
    @IBOutlet weak var ticketView: UITableView!
    
    var menu_showing = false
    var ref = Database.database().reference()
    
    var selectedSkill = String()
    
    var requestUIDS = [Any]()
    var titles = [Any]()
    var names = [Any]()
    var uids = [Any]()
    var images = [Any]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //EMPTY STATE
        self.emptyStateDataSource = self
        self.emptyStateDelegate = self
        // Optionally remove seperator lines from empty cells
        self.ticketView.tableFooterView = UIView(frame: CGRect.zero)
        self.reloadEmptyStateForTableView(self.ticketView)
        //EMPTY STATE

        
        userName.text = Auth.auth().currentUser?.displayName
        print("display name: \(Auth.auth().currentUser?.displayName)")
        
        warningLabel.text = ""
        self.ref.child("REQUESTS").child("STATE").child("NEW_YORK").child("REGION").child("BUFFALO").child("REQUESTED").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            //print(value)
            
            if snapshot.value as? NSDictionary != nil {
                
                for user in value! {
                    let contents = user.value as? NSDictionary
                    
                    let uid = contents?.value(forKey: "requesterId") as? String
                    
                    if uid != Auth.auth().currentUser?.uid {
                        let t = contents?.value(forKey: "title")
                        //print(t)
                        self.titles.append(t)
                        
                        let requestUID = contents?.value(forKey: "requestId")
                        self.requestUIDS.append(requestUID!)
                        
                        //print(uid)
                        self.uids.append(uid!)
                        
                        self.ref.child("USER_ID_DIRECTORY").child(uid as! String).observeSingleEvent(of: .value, with: { (sshot) in
                            let v = sshot.value as? NSDictionary
                            //print(v)
                            
                            let fName = v?.value(forKey: "firstName") as! String
                            let lName = v?.value(forKey: "lastName") as! String
                            let name = "\(fName) \(lName)"
                            
                            self.names.append(name)
                            
                            self.ticketView.reloadData()
                        })
                    }
                    
                }
                self.ticketView.reloadData()
            }
            
        })
        
        
    }
    
    // MARK: - Empty State Data Source
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Set the initial state of the tableview, called here because cells should be done loading by now
        // Number of cells are used to determine if the view should be shown or not
        self.reloadEmptyStateForTableView(self.ticketView)
    }
    
    var emptyStateImage: UIImage? {
        let img = #imageLiteral(resourceName: "cactus")
        return img
    }
    
    var emptyStateTitle: NSAttributedString {
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.882, green: 0.890, blue: 0.859, alpha: 1.00),
                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]
        return NSAttributedString(string: "No Tickets in your Area!", attributes: attrs)
    }
    
//    var emptyStateButtonTitle: NSAttributedString? {
//        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.white,
//                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
//        return NSAttributedString(string: "Submit one to see if anyone's out there", attributes: attrs)
//    }
    
//    var emptyStateButtonSize: CGSize? {
//        return CGSize(width: 100, height: 40)
//    }
    
    
    // MARK: - Empty State Delegate
    
    func emptyStateViewWillShow(view: UIView) {
        guard let emptyView = view as? UIEmptyStateView else { return }
        // Some custom button stuff
        emptyView.button.layer.cornerRadius = 5
        emptyView.button.layer.borderWidth = 1
        emptyView.button.layer.borderColor = UIColor.red.cgColor
        emptyView.button.layer.backgroundColor = UIColor.red.cgColor
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(names.count)")
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //TicketCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as! ViewFeedRequestCell
        
        print("this is what goes in: names: \(self.names[indexPath.row] as? String) titles: \(self.titles[indexPath.row] as? String)")
        
        cell.nameText.text = self.names[indexPath.row] as? String
        cell.titleText.text = self.titles[indexPath.row] as? String
        
        cell.clipsToBounds = true
        
        return (cell)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        print("selected: \(self.requestUIDS[indexPath.row])")
        
        self.selectedSkill = self.requestUIDS[indexPath.row] as! String
        print("selected skill var: \(self.selectedSkill)")
        
        self.performSegue(withIdentifier: "detail_ticket", sender: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 115.0;//Choose your custom row height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NotHelpedView {
            print("IT IS HAPPENING")
            print("assigning from this: \(self.selectedSkill)")
            vc.uid = self.selectedSkill
        }
        
        if let vc = segue.destination as? SplashScreen {
            self.hidesBottomBarWhenPushed = true
        }
    }

    
}

