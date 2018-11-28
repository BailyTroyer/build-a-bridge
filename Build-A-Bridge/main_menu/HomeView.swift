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
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("inside feed view")
        
        //EMPTY STATE
        
        //self.emptyStateDataSource = self
        //self.emptyStateDelegate = self
        
        // Optionally remove seperator lines from empty cells
        self.ticketView.tableFooterView = UIView(frame: CGRect.zero)
        self.reloadEmptyStateForTableView(self.ticketView)
        //EMPTY STATE

        
        userName.text = Auth.auth().currentUser?.displayName
        print("display name: \(Auth.auth().currentUser?.displayName)")
        
        warningLabel.text = ""
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        ticketView.refreshControl = refreshControl
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        print("Hello World!")
        
        // somewhere in your code you might need to call:
        refreshControl.endRefreshing()
    }

    
    // MARK: - Empty State Data Source
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("inside feed view did appear")
        
        self.load_data()
        
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
        return NSAttributedString(string: "Seems like nobody's out there just yet!", attributes: attrs)
    }
    
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
        
        self.ticketView.deselectRow(at: indexPath, animated: true)
        
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
    
    func load_data() {
       
        let sv = UIViewController.displaySpinner(onView: self.view)

        self.wipe_feed()
        self.ref.child("REQUESTS").child("STATE").child("New York").child("REGION").child("Buffalo").child("REQUESTED").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            if snapshot.value as? NSDictionary != nil {
                
                for user in value! {
                    print("user: \(user)")
                    let contents = user.value as? NSDictionary
                    
                    let uid = contents?.value(forKey: "requesterId") as? String
                    
                    if uid != Auth.auth().currentUser?.uid {
                        let t = contents?.value(forKey: "title")
                        print("title: \(t)")
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
                            
                            print("names: \(self.names)")
                            print("DONE")
                            print("refreshing")
                            UIViewController.removeSpinner(spinner: sv)
                            self.ticketView.reloadData()
                        })
                    }
                }
                //self.ticketView.reloadData()
            } else {
                print("DONE")
                print("refreshing")
                UIViewController.removeSpinner(spinner: sv)
                self.ticketView.reloadData()
            }
        })
    }
    
    
    func wipe_feed() {
        self.requestUIDS = []
        self.titles = []
        self.names = []
        self.uids = []
        self.images = []
    }

    
}

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
