//
//  Exercise.swift
//  FollowFitness
//
//  Created by Remko Vermaeren on 22/01/17.
//  Copyright © 2017 Remko Vermaeren. All rights reserved.
//

import Foundation
import SwiftyJSON

class Exercise {
    let id : String
    let name : String
    let machine : String
    var sets : [Set] = []
    
    init(id: String, name : String, machine : String, sets : [Set]) {
        self.id = id
        self.name = name
        self.machine = machine
        self.sets = sets
    }
}
extension Exercise {
    convenience init(json : JSON) {
        let id = json["_id"].stringValue
        let name = json["name"].stringValue
        let machine = json["machine"].stringValue
        let s = json["sets"]
        var sets : [Set] = []
        for (_,subJson):(String, JSON) in s {
            sets.append(Set.init(json: subJson))
        }
        self.init(id: id, name: name, machine: machine, sets: sets)
    }
}
