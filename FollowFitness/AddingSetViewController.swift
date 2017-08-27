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
            self.newSet = Set.init(id: "", repeats: Int(n)!, weights: Int(kilo!)!)

            Service.shared.saveSet(weights: Int(kilo!)!, repeats: Int(n)!, trainingId: trainingId, exerciseId: exerciseId) {
                response in
                switch response {
                case .success( _):
                    self.performSegue(withIdentifier: "saveSet", sender: self)
                case .failure(let error):
                    print(error)
                }
                }
            }
        
        
            
        }
    }


