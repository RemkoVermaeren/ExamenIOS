import UIKit

class AddingViewController: UITableViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateField: UIDatePicker!
    
    var training: Training?
    
  
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    

    @IBAction func save() {
        if let n = nameField.text , n.characters.count > 1 {
            let date = dateField.date
            //training = Training.init(name: n, date: date as NSDate, exercises: [])
            //training!.date = date as NSDate
            //training!.name = name
            
            performSegue(withIdentifier: "added", sender: self)
        }
    }
}
