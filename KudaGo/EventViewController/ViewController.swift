//
//  ViewController.swift
//  tableView11
//
//  Created by Влад on 17/02/2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


var results = [Result]()
var contentOffset: CGFloat?

class ViewController: UIViewController, UITableViewDelegate {
// MARK: IBOutlets
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
// MARK: IBActions
    
// MARK: Properties
    private var eventService = EventsService()
    private let currentDate = Date().timeIntervalSince1970

    
    
// MARK: EventViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isHidden = true
        print(currentDate)
        eventService.loadEvents(currentDate: currentDate){
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
}

//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return events.count
        return eventService.listOfFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? TableViewCell
        let list = eventService.listOfFields[indexPath.row]
        
        cell?.titleLabel.text = list.title.uppercased()//все заглавные
        cell?.descriptionLabel.text = list.description
        
        if let place = eventService.listOfAddres[indexPath.row].address{
            cell?.placeStack.isHidden = false
            cell?.placeLabel.text = place
        }else{
            cell?.placeStack.isHidden = true
        }
        
        let imageURL = eventService.listOfImages[indexPath.row].picture
        //let imageURL = eventService.listOfFields[indexPath.row].images
        let url = URL(string: imageURL)
        
        Alamofire.request(url!).responseImage { (response) in
            if let image = response.result.value{
                cell?.photoEvent.image = image
            }
        }
        
       
        if list.price == ""{
            cell?.priceLabel.text = "Бесплатно"
        }else{
            cell?.priceLabel.text = list.price.capitalized//первая заглавная
        }
        
        return cell!
    }
}
