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
    
    @IBAction func register(_ sender: Any) {
        let parameters: Parameters = [
            "username": username.text!,
            "password": password.text!
        ]
        
        Alamofire.request("http://followfitness.herokuapp.com/register",method: .post,parameters: parameters, encoding: URLEncoding.httpBody).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("Token: \(json["token"])")
            case .failure(let error):
                print(error)
            }
        }

    }
}
