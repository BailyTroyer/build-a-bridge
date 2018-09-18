//
//  Constants.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 9/2/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        //static let databaseChats = databaseRoot.child("chats")
        static let databaseChats = databaseRoot.child("MESSAGES")
    }
}
