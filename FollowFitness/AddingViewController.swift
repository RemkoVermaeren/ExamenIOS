import UIKit
import Alamofire
import SwiftyJSON
class AddingViewController: UITableViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var isCompletedField: UISwitch!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var dateField: UIDatePicker!
    
    var training: Training?
    
  
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    

    @IBAction func save() {
        if let n = nameField.text , n.characters.count > 0 {
            let date = dateField?.date
            let description = descriptionField?.text
            let isCompleted = isCompletedField?.isOn

            Service.shared.saveTraining(name: n, description: description!, date: date!, isCompleted: isCompleted!){
                response in switch response {
                case .success ( _) :
                    self.performSegue(withIdentifier: "added", sender: self)

                case .failure (let error):
                    print(error)
                }
            }
        }
    }
}
