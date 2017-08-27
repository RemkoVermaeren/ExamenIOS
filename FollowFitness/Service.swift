//
//  Service.swift
//  FollowFitness
//
//  Created by Remko Vermaeren on 27/08/2017.
//  Copyright © 2017 Remko Vermaeren. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class Service {
    private var token = UserDefaults.standard.string(forKey: "token")
    private var id = UserDefaults.standard.string(forKey: "id")

    static let shared = Service()
    func resetKeys(){
         token = UserDefaults.standard.string(forKey: "token")
         id = UserDefaults.standard.string(forKey: "id")
    }
    func getUncompletedTrainings(completionHandler : @escaping(BackendResponse) -> Void) -> Void {
        resetKeys()

        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!,
            "Accept": "application/json"
        ]
        Alamofire.request("http://followfitness.herokuapp.com/api/"+id!+"/uncompletedtrainings", method: .get, headers: headers).responseJSON { response in
           
            
            switch response.result {
            case .success(let value):
                var trainings : [Training] = []
                let json = JSON(value)
                
                for (_,subJson):(String, JSON) in json {
                    trainings.append(Training.init(json: subJson))
                }
                completionHandler(BackendResponse.success(trainings))

            case .failure( _):
                completionHandler(BackendResponse.failure("Try again"))
            }
        }
    }
    
    func getCompletedTrainings(completionHandler : @escaping(BackendResponse) -> Void) -> Void {

        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!,
            "Accept": "application/json"
        ]
        Alamofire.request("http://followfitness.herokuapp.com/api/"+id!+"/completedtrainings", method: .get, headers: headers).responseJSON { response in
            
            
            switch response.result {
            case .success(let value):
                var trainings : [Training] = []
                let json = JSON(value)
                for (_,subJson):(String, JSON) in json {
                    trainings.append(Training.init(json: subJson))
                }
                completionHandler(BackendResponse.success(trainings))
                
            case .failure( _):
                completionHandler(BackendResponse.failure("Try again"))
            }
        }
    }
    
    func deleteTraining(trainingId : String, completionHandler : @escaping(BackendResponse) -> Void) -> Void {

        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!,
            "Accept": "application/json"
        ]
        let url = "http://followfitness.herokuapp.com/api/"+id!+"/trainings/" + trainingId
        Alamofire.request(url, method: .delete, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                completionHandler(BackendResponse.success(value))
            case .failure( _):
                completionHandler(BackendResponse.failure("Try again"))
            }
        }
    }
    
    func reverseIsCompleted(trainingId: String, completionHandler : @escaping(BackendResponse) -> Void) -> Void {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!,
            "Accept": "application/json"
        ]
        let url = "http://followfitness.herokuapp.com/api/"+id!+"/trainings/" + trainingId + "/reverseiscompleted"
        Alamofire.request(url, method: .put, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                completionHandler(BackendResponse.success(value))
            case .failure( _):
                completionHandler(BackendResponse.failure("Try again"))
            }
        }

    }
    
    func saveSet(weights : Int, repeats: Int, trainingId: String, exerciseId : String ,completionHandler : @escaping(BackendResponse) -> Void) -> Void {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!,
            "Accept": "application/json"
        ]
        let parameters: Parameters = [
            "weights": weights,
            "repeats": repeats,
            ]

        let url = "http://followfitness.herokuapp.com/api/" + id! + "/trainings/" + trainingId + "/exercises/" + exerciseId + "/sets"
        Alamofire.request(url,method: .put, parameters: parameters, headers: headers)
            .validate(contentType: ["application/json"])
            .responseJSON {
                
                response in
               
                switch response.result {
                case .success(let value):
                    completionHandler(BackendResponse.success(value))
                case .failure( _):
                    completionHandler(BackendResponse.failure("Try again"))
                }
        }
        }
    
        func register(username : String, password : String,completionHandler : @escaping(BackendResponse) -> Void) -> Void {
            let parameters: Parameters = [
                "username": username,
                "password": password
            ]
            
            Alamofire.request("http://followfitness.herokuapp.com/register",method: .post,parameters: parameters, encoding: URLEncoding.httpBody).responseJSON {
                response in
            
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if(json["message"].exists()){
                        completionHandler(BackendResponse.failure(json["message"].stringValue))
                        
                    }else{
                    UserDefaults.standard.set(json["token"].string, forKey: "token")
                    UserDefaults.standard.set(json["id"].string, forKey: "id")
                    completionHandler(BackendResponse.success(value))
                    }
                case .failure( _):
                    completionHandler(BackendResponse.failure("Please try again"))
                }
            }

        }
    func login(username : String, password : String,completionHandler : @escaping(BackendResponse) -> Void) -> Void {
        let parameters: Parameters = [
            "username": username,
            "password": password
        ]
        
        Alamofire.request("http://followfitness.herokuapp.com/login",method: .post,parameters: parameters, encoding: URLEncoding.httpBody).responseJSON {
            response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if(json["message"].exists()){
                    completionHandler(BackendResponse.failure(json["message"].stringValue))

                }else{
                UserDefaults.standard.set(json["token"].string, forKey: "token")
                UserDefaults.standard.set(json["id"].string, forKey: "id")
                completionHandler(BackendResponse.success(value))
                }
            case .failure( _):
                completionHandler(BackendResponse.failure("Try again"))
            }
        }
    }
    
    func saveExercise(name : String, machine : String, trainingId : String ,completionHandler : @escaping(BackendResponse) -> Void) -> Void {
        let parameters: Parameters = [
        "name": name,
        "machine": machine,
        ]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!,
            "Accept": "application/json"
        ]
        let url = "http://followfitness.herokuapp.com/api/" + id! + "/trainings/" + trainingId
        Alamofire.request(url,method: .post, parameters: parameters, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                completionHandler(BackendResponse.success(value))
            case .failure( _):
                completionHandler(BackendResponse.failure("Try again"))
            }
        }
    }
    func getExercises(trainingId : String, completionHandler : @escaping(BackendResponse) -> Void) -> Void {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!,
            "Accept": "application/json"
        ]
        let url = "http://followfitness.herokuapp.com/api/"+id!+"/trainings/" + trainingId + "/exercises"
        Alamofire.request(url, method: .get, headers: headers).responseJSON { response in
            switch response.result {
                case .success(let value):
                var exercises : [Exercise] = []
                let json = JSON(value)
                for (_,subJson):(String, JSON) in json {
                    exercises.append(Exercise.init(json: subJson))
                }
                completionHandler(BackendResponse.success(exercises))
                
                case .failure( _):
                completionHandler(BackendResponse.failure("Try again"))
            }
        }
    }
    
    func deleteExercise(trainingId : String, exerciseId : String, completionHandler : @escaping(BackendResponse) -> Void) -> Void {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!,
            "Accept": "application/json"
        ]
        let url = "http://followfitness.herokuapp.com/api/"+id!+"/trainings/" + trainingId + "/exercises/" + exerciseId
        Alamofire.request(url, method: .delete, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                completionHandler(BackendResponse.success(value))
            case .failure( _):
                completionHandler(BackendResponse.failure("Try again"))
            }
        }
    }
    
    func saveTraining(name : String, description: String, date : Date, isCompleted : Bool, completionHandler : @escaping(BackendResponse) -> Void) -> Void {
        let parameters: Parameters = [
            "name": name,
            "description": description,
            "date" : date,
            "isCompleted" : isCompleted
        ]

        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!,
            "Accept": "application/json"
        ]
        
        Alamofire.request("http://followfitness.herokuapp.com/api/" + id! + "/trainings", method: .post, parameters: parameters, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                completionHandler(BackendResponse.success(value))
            case .failure( _):
                completionHandler(BackendResponse.failure("Try again"))
            }
        }

    }
}

