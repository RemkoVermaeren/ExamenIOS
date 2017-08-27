//
//  CompletedExercisesOverviewController.swift
//  FollowFitness
//
//  Created by Remko Vermaeren on 27/08/2017.
//  Copyright © 2017 Remko Vermaeren. All rights reserved.
//

import Foundation
import UIKit

class CompletedExercisesOverviewController : UITableViewController {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExerciseCell
        let exercise = training!.exercises[indexPath.row]
        cell.name.text = "\(exercise.name)"
        cell.machine.text = "\(exercise.machine)"
        return cell
    }
    // Moet werken maar krijg error bij de detail segue
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                switch segue.identifier! {
                case "sets":
                    let destination = segue.destination as! SetOverviewViewController
                    let selectedIndex = tableView.indexPathForSelectedRow!.row
                    destination.exercise = training?.exercises[selectedIndex]
                default:
                    break
                }
            }
    
}
