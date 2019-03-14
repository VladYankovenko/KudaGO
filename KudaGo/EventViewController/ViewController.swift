//
//  ViewController.swift
//  tableView11
//
//  Created by Влад on 17/02/2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import UIKit


var events = [Eve]()
var results = [Result]()
var event11 = [Events]()
var contentOffset: CGFloat?




class ViewController: UIViewController, UITableViewDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: IBActions
    
    // MARK: Properties
    private var eventService = EventsService()
   // private var event1 = [Event]()
    
    
    
    // MARK: EventViewController
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isHidden = true
        
        eventService.loadEvents(){
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       events.removeAll()
        //loadEvents()
        
        
       
        
    }
    
    private func loadEvents() {
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
        events = [ meal1 , meal2 , meal3 ]
    }
}
 
    //MARK: UITableViewDataSource
    
extension ViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return events.count
        return eventService.listOfFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? TableViewCell /*else {
         fatalError("The dequeued cell is not an instance of MealTableViewCell.")
         }*/
        //let meal = events[indexPath.row]
        /*
        cell?.aboutLabel.text = meal.about
        cell?.nameLable.text = meal.name
        cell?.photoEvent.image = meal.photo*/
        
        let list = eventService.listOfFields[indexPath.row]
        
        cell?.titleLabel.text = list.title.uppercased()//все заглавные
        //cell?.placeLabel.text = list.title
        //cell?.dateLable.text = list.slug
       
        let descriptionClear = String(list.description.dropFirst(3))
        
        cell?.descriptionLabel.text = descriptionClear
        if list.price == ""{
            cell?.priceLabel.text = "Бесплатно"
        }else{
            cell?.priceLabel.text = list.price.capitalized//первая заглавная
        }
    
        
        //cell?.photoEvent.image = meal.photo
        
        return cell!
    }
}

    
    
    

    
    
  
    
    
    
    
    




