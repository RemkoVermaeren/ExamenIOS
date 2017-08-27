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
import MGSwipeTableCell

class TrainingOverviewViewController: UITableViewController {
    var trainingList : [Training] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTraining()
    }
    
    func loadTraining(){
        trainingList.removeAll()
        let token = UserDefaults.standard.string(forKey: "token")
        let id = UserDefaults.standard.string(forKey: "id")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!,
            "Accept": "application/json"
        ]
        Alamofire.request("http://followfitness.herokuapp.com/api/"+id!+"/uncompletedtrainings", method: .get, headers: headers).responseJSON { response in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "trainingCell", for: indexPath) as! MGSwipeTableCell
        let training = trainingList[indexPath.row]
        cell.textLabel!.text = "\(training.name)"
        let formatterToNewDate = DateFormatter()
        formatterToNewDate.dateFormat = "EEEE, MMM d, yyyy"
        let dateAsString = formatterToNewDate.string(from: training.date as Date)
        cell.detailTextLabel!.text = dateAsString
        
        let button : MGSwipeButton = MGSwipeButton(title: "Done", backgroundColor: .green) {
            (sender: MGSwipeTableCell!) -> Bool in
            let indexPath = self.tableView.indexPath(for: cell)
            let training = self.trainingList[indexPath!.row]
            self.trainingList.remove(at: indexPath!.row)
            let token = UserDefaults.standard.string(forKey: "token")
            let id = UserDefaults.standard.string(forKey: "id")
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + token!,
                "Accept": "application/json"
            ]
            let url = "http://followfitness.herokuapp.com/api/"+id!+"/trainings/" + training.id + "/reverseiscompleted"
            Alamofire.request(url, method: .put, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let value):
                    print(JSON(value))
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print(error)
                }
            }
            
            return true
        }
        cell.leftButtons = [button]
        cell.leftSwipeSettings.transition = .drag
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
        loadTraining()
    }
    
    
    /* Overriding this method triggers swipe actions (e.g. swipe to delete) */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.tableView.beginUpdates()
            let training = trainingList[indexPath.row]
            trainingList.remove(at: indexPath.row)
            tableView.deleteRows(at:[indexPath], with: .automatic)
            self.tableView.endUpdates()
            
            let token = UserDefaults.standard.string(forKey: "token")
            let id = UserDefaults.standard.string(forKey: "id")
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + token!,
                "Accept": "application/json"
            ]
            let url = "http://followfitness.herokuapp.com/api/"+id!+"/trainings/" + training.id
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
    
    func reverseComplete(gestureReconizer: UILongPressGestureRecognizer){
        
        let longPress = gestureReconizer as UILongPressGestureRecognizer
        _ = longPress.state
        let locationInView = longPress.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: locationInView)
        let training = trainingList[indexPath!.row]
        trainingList.remove(at: indexPath!.row)
        let token = UserDefaults.standard.string(forKey: "token")
        let id = UserDefaults.standard.string(forKey: "id")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!,
            "Accept": "application/json"
        ]
        let url = "http://followfitness.herokuapp.com/api/"+id!+"/trainings/" + training.id + "/reverseiscompleted"
        Alamofire.request(url, method: .put, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print(JSON(value))
                self.tableView.reloadData()

            case .failure(let error):
                print(error)
            }
        }


    
    }
}
