//
//  RegisterViewController.swift
//  FollowFitness
//
//  Created by Remko Vermaeren on 21/08/2017.
//  Copyright © 2017 Remko Vermaeren. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController{
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorlabel: UILabel!

    @IBAction func register(_ sender: Any) {
        
        
        Service.shared.register(username: username.text!, password: password.text!){
            response in
            switch response {
            case .success( _):
                self.performSegue(withIdentifier: "showTrainings", sender: self)
            case .failure(let error):
                self.errorlabel.text = "\(error)"
            }
        }
    }
}
