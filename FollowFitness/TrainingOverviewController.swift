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

class TrainingOverviewViewController: UITableViewController {
    var trainingList : [Training] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTraining()
    }
    
    func loadTraining(){
        
        let token = UserDefaults.standard.string(forKey: "token")
        let id = UserDefaults.standard.string(forKey: "id")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!,
            "Accept": "application/json"
        ]
        Alamofire.request("http://followfitness.herokuapp.com/api/"+id!+"/trainings", method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_,subJson):(String, JSON) in json {
                    self.trainingList.append(Training.init(json: subJson))
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
        return trainingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "trainingCell", for: indexPath)
                let training = trainingList[indexPath.row]
                cell.textLabel!.text = "\(training.name)"
                let formatterToNewDate = DateFormatter()
                formatterToNewDate.dateFormat = "EEEE, MMM d, yyyy"
                let dateAsString = formatterToNewDate.string(from: training.date as Date)
                cell.detailTextLabel!.text = dateAsString
                return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "exercise":
            let destination = segue.destination as! ExerciseOverviewViewController
            let selectedIndex = tableView.indexPathForSelectedRow!.row
            destination.training = trainingList[selectedIndex]
        default:
            break
        }
    }
    
    @IBAction func unwindFromAdd(_ segue: UIStoryboardSegue) {
        let source = segue.source as! AddingViewController
        if source.training != nil {
            tableView.beginUpdates()
//            try! self.realm.write({
//                self.realm.add(training)
//                self.tableView.insertRows(at: [IndexPath.init(row: self.trainingList.count-1, section: 0)], with: .automatic)
//            })
            tableView.endUpdates()
        }
    }
    
    /* Overriding this method triggers swipe actions (e.g. swipe to delete) */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
                _ = trainingList[indexPath.row]
//                try! self.realm.write({
//                    self.realm.delete(item)
//                })
            
                tableView.deleteRows(at:[indexPath], with: .automatic)
                
            }
            tableView.endUpdates()
        
    }
    
   
}
