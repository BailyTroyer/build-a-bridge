//
//  LoadFile.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 10/10/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit

struct objects {
    var skills: [skill]
    var users: [user]
}

//var skills: [skill]

struct skill {
    var image: UIImage
    var name: String
}

struct user {
    var name: String
    var uid: String
    var skills: [skill]
    
}
