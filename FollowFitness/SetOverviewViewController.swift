//
//  SetOverviewViewController.swift
//  FollowFitness
//
//  Created by Remko Vermaeren on 27/08/2017.
//  Copyright © 2017 Remko Vermaeren. All rights reserved.
//

import Foundation
import UIKit

class SetOverviewViewController : UITableViewController {
    
    var trainingId : String = ""
    var exercise: Exercise?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercise!.sets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setCell", for: indexPath) as! SetCell
        let set = exercise?.sets[indexPath.row]
        cell.kilos.text = "\(set!.weights) kg"
        cell.repeats.text = "\(set!.repeats) times"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "addSet":
            let destination = segue.destination as! AddingSetViewController
            destination.trainingId = trainingId
            destination.exerciseId = exercise!.id
        default:
            break
        }
    }
    
    @IBAction func unwindFromAddSet(_ segue: UIStoryboardSegue) {
        switch segue.identifier! {
            case "saveSet":
            let origin = segue.source as! AddingSetViewController
            if origin.newSet != nil {
                exercise?.sets.append(origin.newSet!)
                self.tableView.reloadData()
            }
           
        default :
            break
        }
    }
}
