//
//  Match.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-07-27.
//  Copyright © 2017 Chris Dean. All rights reserved.
//

import Foundation
import Firebase

struct Match {
    
    let suitorsName: String
    let suitorsUid: String
    let location: String
    
    init(suitorsName: String, suitorsUid: String, location: String) {
        self.suitorsName = suitorsName
        self.suitorsUid = suitorsUid
        self.location = location
    }
}
