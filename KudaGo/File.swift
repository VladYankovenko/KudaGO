
import UIKit

class Eve {
    
    //MARK: Properties
    
    var name: String
    var about: String
    var photo: UIImage?
    
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, about: String) {
        // Initialization should fail if there is no name or if the rating is negative.
        // The name must not be empty
        
        // Initialize stored properties.
        self.name = name
        self.about = about
        self.photo = photo
       // loadEvents()
        
    }
    
  /*  private func loadEvents() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        guard let meal1 = Eve(name: "Caprese Salad", photo: photo1, about: "Event 1") else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal2 = Eve(name: "Chicken and Potatoes", photo: photo2, about: "Event 2") else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Eve(name: "Pasta with Meatballs", photo: photo3, about: "Event 3") else {
            fatalError("Unable to instantiate meal2")
        }
        events += [ meal1 , meal2 , meal3 ]
    }*/
    
}
