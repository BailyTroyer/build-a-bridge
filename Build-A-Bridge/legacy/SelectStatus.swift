//
//  SelectStatus.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 7/21/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit

class SelectStatus: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func refugeeNext(_ sender: Any) {
        self.performSegue(withIdentifier: "selected_status", sender: self)
    }
    @IBAction func volunteerNext(_ sender: Any) {
        self.performSegue(withIdentifier: "selected_status", sender: self)
    }
    
    

}
