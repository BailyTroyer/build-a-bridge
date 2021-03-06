//
//  RequestSubmittedView.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 10/10/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit

class RequestSubmittedView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        destinationVC.hidesBottomBarWhenPushed = false
    }
    
    @IBAction func done(_ sender: Any) {
        //self.performSegue(withIdentifier: "done_request_create", sender: self)
        self.performSegue(withIdentifier: "go_back", sender: self)
    }
}
