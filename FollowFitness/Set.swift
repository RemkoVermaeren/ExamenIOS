//
//  Set.swift
//  FollowFitness
//
//  Created by Remko Vermaeren on 21/08/2017.
//  Copyright © 2017 Remko Vermaeren. All rights reserved.
//

import Foundation
import SwiftyJSON

class Set {
    let id : String
    let repeats : Int
    let weights : Int
    init(id: String, repeats : Int, weights: Int) {
        self.id = id
        self.repeats = repeats
        self.weights = weights
    }
}

extension Set {
    convenience init(json : JSON) {
        let id = json["_id"].stringValue
        let repeats = json["repeat"].int
        let weights = json["weight"].int
        self.init(id: id, repeats: repeats!, weights: weights!)
    }
}
