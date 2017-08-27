import UIKit
import Alamofire
import SwiftyJSON

class AddingExerciseViewController: UITableViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var machineField: UITextField!
    
    var training: Training?
    
    
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    @IBAction func save() {
    if let n = nameField.text , n.characters.count >= 1 {
        let machine = machineField?.text
        Service.shared.saveExercise(name: n, machine: machine!, trainingId: training!.id){
            response in
            switch response {
            case .success( _):
                self.performSegue(withIdentifier: "saveExercise", sender: self)
            case .failure(let error):
                print(error)
            }

        }
    }
    }
}
