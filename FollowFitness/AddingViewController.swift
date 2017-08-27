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
        if let n = nameField.text , n.characters.count > 1 {
            let date = dateField?.date
            let description = descriptionField?.text
            let isCompleted = isCompletedField?.isOn
          
            //training!.date = date as NSDate
            //training!.name = name
            
            let parameters: Parameters = [
                "name": n,
                "description": description!,
                "date" : date!,
                "isCompleted" : isCompleted!
            ]
            let token = UserDefaults.standard.string(forKey: "token")
            let id = UserDefaults.standard.string(forKey: "id")
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + token!,
                "Accept": "application/json"
            ]
            
            Alamofire.request("http://followfitness.herokuapp.com/api/" + id! + "/trainings",method: .post, parameters: parameters, headers: headers).responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    print(JSON(value))
                    self.performSegue(withIdentifier: "added", sender: self)
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
}
