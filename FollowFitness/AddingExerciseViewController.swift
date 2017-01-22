import UIKit

class AddingExerciseViewController: UITableViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var kiloField: UITextField!
    @IBOutlet weak var setField: UITextField!
    @IBOutlet weak var repeatField: UITextField!
    
    var exercise: Exercise?
    
    
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    @IBAction func save() {
        if let name = nameField.text , name.characters.count > 1 {
            let kilo = Int(kiloField.text!)
            let set = Int(setField.text!)
            let repeats = Int(repeatField.text!)
            exercise = Exercise()
            exercise?.name = name
            exercise?.kilo = kilo!
            exercise?.sets = set!
            exercise?.repeats = repeats!
            performSegue(withIdentifier: "addedExercise", sender: self)
        }
    }
}
