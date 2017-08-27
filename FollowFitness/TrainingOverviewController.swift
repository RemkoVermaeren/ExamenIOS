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
        Service.shared.getUncompletedTrainings { response in
            switch response {
            case .success( let trainings) :
                self.trainingList = trainings as! [Training]
                self.tableView.reloadData()
            
            case .failure (let error) :
            print(error)
            }
        }
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
            Service.shared.reverseIsCompleted(trainingId: training.id){ response in
                switch response {
                case .success( _) :
                    self.trainingList.remove(at: indexPath!.row)
                    self.tableView.reloadData()
                case .failure( _) : break
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let training = trainingList[indexPath.row]
                       Service.shared.deleteTraining(trainingId: training.id) { response in
                switch response {
                case .success( _):
                    self.tableView.beginUpdates()
                    self.trainingList.remove(at: indexPath.row)
                    tableView.deleteRows(at:[indexPath], with: .automatic)
                    self.tableView.endUpdates()
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    }
}
