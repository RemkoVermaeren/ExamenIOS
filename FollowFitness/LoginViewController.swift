//
//  LoginViewController.swift
//  FollowFitness
//
//  Created by Remko Vermaeren on 21/08/2017.
//  Copyright © 2017 Remko Vermaeren. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController : UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    @IBOutlet weak var btnLogIn: UIButton!
    
    @IBAction func logIn(_ sender: Any) {
        Service.shared.login(username: usernameField.text!, password: passwordField.text!){
            response in
            switch response {
            case .success(let value):
                print(value)
                self.performSegue(withIdentifier: "showTrainings", sender: self)
            case .failure(let error):
                self.errorLabel.text = "\(error)"
            }
        }
    }
    
    @IBAction func unwindFromLogout(_ segue: UIStoryboardSegue) {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "id")
    }
    
}
