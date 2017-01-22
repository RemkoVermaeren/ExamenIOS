//
//  TrainingOverviewController.swift
//  FollowFitness
//
//  Created by Remko Vermaeren on 22/01/17.
//  Copyright © 2017 Remko Vermaeren. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
class TrainingOverviewViewController: UITableViewController {
    let realm = try! Realm()
    var trainingList : Results<Training> {
        get {
            return realm.objects(Training.self)
        }
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
                cell.detailTextLabel!.text = "\(training.date)"
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
        if let training = source.training {
            tableView.beginUpdates()
            try! self.realm.write({
                self.realm.add(training)
                self.tableView.insertRows(at: [IndexPath.init(row: self.trainingList.count-1, section: 0)], with: .automatic)
            })
            tableView.endUpdates()
        }
    }
    
    /* Overriding this method triggers swipe actions (e.g. swipe to delete) */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
                let item = trainingList[indexPath.row]
                try! self.realm.write({
                    self.realm.delete(item)
                })
                
                tableView.deleteRows(at:[indexPath], with: .automatic)
                
            }
            tableView.endUpdates()
        
    }
    
   
}
