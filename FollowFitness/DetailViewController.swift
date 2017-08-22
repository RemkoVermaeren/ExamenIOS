import UIKit

class DetailViewController: UITableViewController {
    
    
    
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var repeatView: UILabel!
    @IBOutlet weak var kiloView: UILabel!
    @IBOutlet weak var setView: UILabel!
    
    var exercise: Exercise!
    
    override func viewDidLoad() {
        title = exercise.name
        //repeatView.text = "\(exercise.repeats)"
        //kiloView.text = "\(exercise.kilo)"
        //setView.text = "\(exercise.sets)"
    }
    
   
   }
