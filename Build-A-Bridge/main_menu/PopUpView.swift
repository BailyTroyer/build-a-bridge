//
//  PopUpView.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 8/22/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit

class PopUpView: UIViewController {
    
    @IBOutlet weak var popUp: UIView!

    @IBOutlet weak var skillName: UILabel!
    @IBOutlet weak var skillDesc: UILabel!
    
    var name:String = ""
    var desc:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUp.layer.cornerRadius = 10
        popUp.layer.masksToBounds = true
        
        view.isOpaque = false
        view.backgroundColor = .clear
        
        self.skillName.text = self.name
        self.skillDesc.text = self.desc
        
    }
    
    @IBAction func done(_ sender: Any) {
        //_ = navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
}
