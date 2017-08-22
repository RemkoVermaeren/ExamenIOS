//
//  TrainingOverviewController.swift
//  FollowFitness
//
//  Created by Remko Vermaeren on 22/01/17.
//  Copyright © 2017 Remko Vermaeren. All rights reserved.
//

import Foundation
import UIKit
class ExerciseOverviewViewController: UITableViewController {
    
    var training: Training?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load the cell elements
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return training!.exercises.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
        let exercise = training!.exercises[indexPath.row]
        cell.textLabel!.text = "\(exercise.name)"
        return cell
        
        
    }
    // Moet werken maar krijg error bij de detail segue
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            switch segue.identifier! {
//            case "detail":
//                let destination = segue.destination as! DetailViewController
//                let selectedIndex = tableView.indexPathForSelectedRow!.row
//                destination.exercise = training?.exercises[selectedIndex]
//            default:
//                break
//            }
//        }
    
    @IBAction func unwindFromAdd(_ segue: UIStoryboardSegue) {
        let source = segue.source as! AddingExerciseViewController
        if let exercise = source.exercise {
            tableView.beginUpdates()
//            try! self.realm.write({
//                training?.exercises.append(exercise)
//                self.realm.add(exercise)
//                self.tableView.insertRows(at: [IndexPath.init(row: (self.training?.exercises.count)!-1, section: 0)], with: .automatic)
//            })
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let item = training?.exercises[indexPath.row]
//            try! self.realm.write({
//                training?.exercises.remove(objectAtIndex: indexPath.row)
//                self.realm.delete(item!)
//            })
            
            tableView.deleteRows(at:[indexPath], with: .automatic)
            
        }
        tableView.endUpdates()
        
    }
    
    
}
