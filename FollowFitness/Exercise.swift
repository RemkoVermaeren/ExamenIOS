//
//  Exercise.swift
//  FollowFitness
//
//  Created by Remko Vermaeren on 22/01/17.
//  Copyright © 2017 Remko Vermaeren. All rights reserved.
//

import Foundation
import RealmSwift

class Exercise: Object {
    var name = ""
    var repeats = 0
    var kilo = 0
    var sets = 0
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
