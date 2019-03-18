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
    private let placeHolder = UIImage(named: "placeholder")

    
    
// MARK: EventViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isHidden = true
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
        return eventService.listOfFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? TableViewCell
        loadDataInTable(in: cell!, indexPath: indexPath)
        
        return cell!
    }
}

//MARK: extentions ViewController
extension ViewController{
    
    private func loadDataInTable(in cell: TableViewCell, indexPath: IndexPath){
        let list = eventService.listOfFields[indexPath.row]
        
        //загрузка описания
        cell.titleLabel.text = list.title.uppercased()
        cell.descriptionLabel.text = list.description
        
        //загрузка места
        if let place = eventService.listOfAddres[indexPath.row].address{
            //Добавить исчезновение стека
            cell.placeLabel.text = place
        }else{
            //Добавить исчезновение стека
        }
        //загрузка картинок в ленту
        let imageURL = eventService.listOfImages[indexPath.row].picture
        let url = URL(string: imageURL)
        
        cell.photoEvent.af_setImage(withURL: url!, placeholderImage: placeHolder)
        
        //загрузка цены
        if list.price == ""{
            cell.priceLabel.text = "Бесплатно"
        }else{
            cell.priceLabel.text = list.price.capitalized//первая заглавная
        }
        //загрузка даты
        let dateStart =  Date(timeIntervalSince1970: eventService.listOfDates[indexPath.row].start)
        let dateEnd =  Date(timeIntervalSince1970: eventService.listOfDates[indexPath.row].end)
       // print(dateStart, dateEnd)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        let startFormatter = dateFormatter.string(from: dateStart)
        let endFormatter = dateFormatter.string(from: dateEnd)
        
        
        print(startFormatter, endFormatter)
       
    }
}

