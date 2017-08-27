//
//  DetailCompletedTrainingController.swift
//  FollowFitness
//
//  Created by Remko Vermaeren on 27/08/2017.
//  Copyright © 2017 Remko Vermaeren. All rights reserved.
//

import Foundation
import UIKit

class DetailCompletedTrainingController : UITableViewController {
    
    var training: Training?

    
    @IBOutlet weak var dateField: UIDatePicker!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var isCompletedField: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = training?.name
        dateField.isUserInteractionEnabled = false
        dateField.date = training?.date as! Date
        descriptionField.text = training?.description
        isCompletedField.isOn = (training?.isCompleted)!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
   
        case "exercises":
            let destination = segue.destination as! CompletedExercisesOverviewController
            destination.training = self.training
        default:
            break
        }
    }
}
