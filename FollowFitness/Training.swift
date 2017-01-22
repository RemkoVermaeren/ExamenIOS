//
//  Training.swift
//  FollowFitness
//
//  Created by Remko Vermaeren on 22/01/17.
//  Copyright © 2017 Remko Vermaeren. All rights reserved.
//

import Foundation
import RealmSwift

class Training: Object {
    dynamic var name = ""
    dynamic var date = NSDate()
    let exercises = List<Exercise>()
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
