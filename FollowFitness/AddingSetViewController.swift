//
//  AddingSetViewController.swift
//  FollowFitness
//
//  Created by Remko Vermaeren on 26/08/2017.
//  Copyright © 2017 Remko Vermaeren. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class AddingSetViewController : UITableViewController {
    @IBOutlet weak var repeats: UITextField!
    @IBOutlet weak var kilos: UITextField!
    
    var trainingId: String = ""
    var exerciseId : String = ""
    
    var newSet : Set? 
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    @IBAction func save() {
        if let n = repeats.text , n.characters.count > 0 {
            let kilo = kilos?.text
            
            let parameters: Parameters = [
                "weights": Int(kilo!)!,
                "repeats": Int(n)!,
                ]
            self.newSet = Set.init(id: "", repeats: Int(n)!, weights: Int(kilo!)!)
            let token = UserDefaults.standard.string(forKey: "token")
            let id = UserDefaults.standard.string(forKey: "id")
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + token!,
                "Accept": "application/json"
            ]
            let url = "http://followfitness.herokuapp.com/api/" + id! + "/trainings/" + trainingId + "/exercises/" + exerciseId + "/sets"
            Alamofire.request(url,method: .put, parameters: parameters, headers: headers)
                .validate(contentType: ["application/json"])
                .responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    print(JSON(value))
                    self.performSegue(withIdentifier: "saveSet", sender: self)
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
}

