//
//  User.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-06-19.
//  Copyright © 2017 Chris Dean. All rights reserved.
//

import Foundation
import Firebase

struct FirebaseUser {
    
    let uid: String
    let email: String
    let name: String
    let profileURL: URL
    
    init(authData: User) {
        uid = authData.uid
        email = authData.email!
        name = authData.displayName!
        profileURL = authData.photoURL!
    }
    
    init(uid: String, email: String, name: String, profileURL: URL) {
        self.uid = uid
        self.email = email
        self.name = name
        self.profileURL = profileURL
    }
    
}
