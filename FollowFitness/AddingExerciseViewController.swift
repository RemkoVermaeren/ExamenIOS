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
        
        let parameters: Parameters = [
            "name": n,
            "machine": machine!,
        ]
        let token = UserDefaults.standard.string(forKey: "token")
        let id = UserDefaults.standard.string(forKey: "id")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token!,
            "Accept": "application/json"
        ]
        let url = "http://followfitness.herokuapp.com/api/" + id! + "/trainings/" + training!.id
        Alamofire.request(url,method: .post, parameters: parameters, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                print(JSON(value))
                self.performSegue(withIdentifier: "saveExercise", sender: self)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    }
}
