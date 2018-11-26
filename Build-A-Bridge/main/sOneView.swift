//
//  sOneView.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 11/21/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class sOneView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let animationView = LOTAnimationView(name: "world_locations")
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        
        view.addSubview(animationView)
        
        animationView.play()
        
        animationView.loopAnimation = true
    }
}
