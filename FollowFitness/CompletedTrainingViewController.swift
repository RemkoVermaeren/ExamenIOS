//
//  CompletedTrainingViewController.swift
//  FollowFitness
//
//  Created by Remko Vermaeren on 27/08/2017.
//  Copyright © 2017 Remko Vermaeren. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class CompletedTrainingViewController : UITableViewController {
    
    var trainingList : [Training] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadCompletedTrainings(){
        trainingList.removeAll()
        let token = UserDefaults.standard.string(forKey: "token")
        let id = UserDefaults.standard.string(forKey: "id")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!,
            "Accept": "application/json"
        ]
        Alamofire.request("http://followfitness.herokuapp.com/api/"+id!+"/completedtrainings", method: .get, headers: headers).responseJSON { response in
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
    
    override func viewWillAppear(_ animated: Bool) {
        loadCompletedTrainings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "completedTrainingCell", for: indexPath)
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
            case "detailTraining":
                let destination = segue.destination as! DetailCompletedTrainingController
                let selectedIndex = tableView.indexPathForSelectedRow!.row
                destination.training = trainingList[selectedIndex]
        case "exercise":
            let destination = segue.destination as! ExerciseOverviewViewController
            let selectedIndex = tableView.indexPathForSelectedRow!.row
            destination.training = trainingList[selectedIndex]
        default:
            break
        }
    }

    
    
}
