//
//  TrainingOverviewController.swift
//  FollowFitness
//
//  Created by Remko Vermaeren on 22/01/17.
//  Copyright © 2017 Remko Vermaeren. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ExerciseOverviewViewController: UITableViewController {
    
    var training: Training?
    var exercises : [Exercise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExercises()
        //Load the cell elements
    }
    func loadExercises(){
        exercises.removeAll()
        let token = UserDefaults.standard.string(forKey: "token")
        let id = UserDefaults.standard.string(forKey: "id")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!,
            "Accept": "application/json"
        ]
        let url = "http://followfitness.herokuapp.com/api/"+id!+"/trainings/" + training!.id + "/exercises"
        Alamofire.request(url, method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_,subJson):(String, JSON) in json {
                    self.exercises.append(Exercise.init(json: subJson))
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
        let exercise = exercises[indexPath.row]
        cell.textLabel!.text = "\(exercise.name)"
        return cell
        
        
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            switch segue.identifier! {
            case "showSets":
                let destination = segue.destination as! SetOverviewViewController
                let selectedIndex = tableView.indexPathForSelectedRow!.row
                destination.exercise = exercises[selectedIndex]
                destination.trainingId = training!.id
            case "addExercise":
                let destination = segue.destination as! AddingExerciseViewController
                destination.training = training!
            default:
                break
            }
        }
    
    @IBAction func unwindFromAddExercise(_ segue: UIStoryboardSegue) {
       loadExercises()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                self.tableView.beginUpdates()
                let exercise = exercises[indexPath.row]
                exercises.remove(at: indexPath.row)
                tableView.deleteRows(at:[indexPath], with: .automatic)
                self.tableView.endUpdates()
                
                let token = UserDefaults.standard.string(forKey: "token")
                let id = UserDefaults.standard.string(forKey: "id")
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + token!,
                    "Accept": "application/json"
                ]
                let url = "http://followfitness.herokuapp.com/api/"+id!+"/trainings/" + training!.id + "/exercises/" + exercise.id
                Alamofire.request(url, method: .delete, headers: headers).responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        print(JSON(value))
                    case .failure(let error):
                        print(error)
                    }
                }
            }
    }
    
    
}
