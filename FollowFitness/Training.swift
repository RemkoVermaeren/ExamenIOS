//
//  Training.swift
//  FollowFitness
//
//  Created by Remko Vermaeren on 22/01/17.
//  Copyright © 2017 Remko Vermaeren. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class Training {
    let name : String
    let date : NSDate
    let id : String
    let description : String
    let isCompleted : Bool
    var exercises : [Exercise] = []
    
    init(id: String ,name: String, date : NSDate, description: String, isCompleted: Bool,exercises: [Exercise]) {
        self.id = id
        self.name = name
        self.date = date
        self.description = description
        self.isCompleted = isCompleted
        self.exercises = exercises
    }
    
    
}

extension Training {
    convenience init(json : JSON) {
        let id = json["_id"].stringValue
        let name = json["name"].stringValue
        let d1 = json["date"].stringValue
        let formatterToNewDate = DateFormatter()
        formatterToNewDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let d2 = formatterToNewDate.date(from: d1)! as NSDate
        let description = json["description"].stringValue
        let isCompleted = json["isCompleted"].boolValue
        let exer = json["exercises"]
        var exercises : [Exercise] = []
        for (_,subJson):(String, JSON) in exer {
            exercises.append(Exercise.init(json: subJson))
        }
        self.init(id: id,name : name, date: d2,description: description,isCompleted: isCompleted,exercises: exercises)
    }
}
