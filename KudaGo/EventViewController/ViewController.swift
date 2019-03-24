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

let logoImageView = UIImageView(image: UIImage(named: "big-logo"))
var results = [Result]()
var contentOffset: CGFloat?
var myIndex = 0


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
        setupNavigationBar()
        tableView.separatorStyle = .none
        
        
        //navigationController?.navigationBar.isHidden = true
        
        eventService.loadEvents(currentDate: currentDate){
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // navigationController?.navigationBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue , sender: Any?) {
        if segue.identifier == "ShowDetailTable"{
            if let indexPath  = tableView.indexPathForSelectedRow {
                let detailTVController = segue.destination as! DetailTableViewController
                detailTVController.textDet = eventService.listOfFields[indexPath.row].description
                detailTVController.textTitle = eventService.listOfFields[indexPath.row].title
                
            }
        }
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        //detailTVController.text = "hello\(indexPath)"
        
        performSegue(withIdentifier: "ShowDetailTable", sender: self)
        
        
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
    
    private struct Const {
        /// Высота / ширина изображения для состояния Big NavBar
        static let ImageHeightSizeForSmallState: CGFloat = 32
        
        static let ImageWidthSizeForSmallState: CGFloat = 77.6
        
        /// Отступ на право
        static let ImageRightMargin: CGFloat = 281.4
        
        /// отступ снизу до нав бара
        static let ImageBottomMarginForLargeState: CGFloat = 6
        
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 32
        
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
        
        /// Image height/width for Landscape state
        static let ScaleForImageSizeForLandscape: CGFloat = 0.65
    }
    
    private func setupNavigationBar(){
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(logoImageView)
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.white
        navigationBar.setValue(true, forKey: "hidesShadow")
        
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                             constant: -Const.ImageRightMargin),
            logoImageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                              constant: -Const.ImageBottomMarginForLargeState),
            logoImageView.heightAnchor.constraint(equalToConstant: Const.ImageHeightSizeForSmallState),
            logoImageView.widthAnchor.constraint(equalToConstant: Const.ImageWidthSizeForSmallState)
            ])
    }
    
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        let startFormatter = dateFormatter.string(from: dateStart)
        let endFormatter = dateFormatter.string(from: dateEnd)
        
        let equalsToDay = Calendar.current.isDate(dateStart, equalTo: dateEnd, toGranularity: .day)
        let equalsToMonth = Calendar.current.isDate(dateStart, equalTo: dateEnd, toGranularity: .month)
        
        if equalsToDay == true{
            cell.dateLabel.text = startFormatter
        }else if equalsToMonth == true && equalsToDay == false {
            let onlyDay = Calendar.current.component(.day, from: dateStart)
             cell.dateLabel.text = "\(onlyDay) - \(endFormatter)"
        }else{
            cell.dateLabel.text = "\(startFormatter) - \(endFormatter)"
        }
       
    }
}

