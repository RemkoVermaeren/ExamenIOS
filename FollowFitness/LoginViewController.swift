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

    @IBOutlet weak var btnLogIn: UIButton!
    
    @IBAction func logIn(_ sender: Any) {
        let parameters: Parameters = [
            "username": usernameField.text!,
            "password": passwordField.text!
        ]
        
        Alamofire.request("http://followfitness.herokuapp.com/login",method: .post,parameters: parameters, encoding: URLEncoding.httpBody).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                UserDefaults.standard.set(json["token"].string, forKey: "token")
                UserDefaults.standard.set(json["id"].string, forKey: "id")
                print(json)
                self.performSegue(withIdentifier: "showTrainings", sender: self)
            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func unwindFromLogout(_ segue: UIStoryboardSegue) {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "id")
}

}
