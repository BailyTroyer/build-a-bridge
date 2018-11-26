//
//  ReportUserView.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 11/14/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit

class ReportUserView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var reportView: UITableView!
    var uid: String = ""
    var issues = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reportView.delegate = self
        self.reportView.dataSource = self
        self.issues = ["verbal harassement", "physical harassement", "damage of property", "verbal abuse", "physical abuse"]
        self.reportView.reloadData()
        print("UID TO REVIEW: \(self.uid)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("THIS: \(self.issues[indexPath.row])")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportC", for: indexPath) as! ReportCell
        cell.name.text = self.issues[indexPath.row]
        
        return (cell)
    }
}
