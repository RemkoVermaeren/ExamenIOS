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
    }
    func loadExercises(){
        exercises.removeAll()
        Service.shared.getExercises(trainingId: training!.id){ response in
            switch response {
            case .success( let value) :
                self.exercises = value as! [Exercise]
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
        return exercises.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExerciseCell
        let exercise = exercises[indexPath.row]
        cell.name.text = "\(exercise.name)"
        cell.machine.text = "\(exercise.machine)"
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
                Service.shared.deleteExercise(trainingId: training!.id, exerciseId: exercise.id){
                    response in
                    switch response {
                    case .success( _):
                        self.exercises.remove(at: indexPath.row)
                        self.tableView.deleteRows(at:[indexPath], with: .automatic)
                        self.tableView.endUpdates()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
    }
    
    
}
