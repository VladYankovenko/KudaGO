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



class ViewController: UIViewController, UITableViewDelegate{
// MARK: IBOutlets
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
// MARK: IBActions
    
// MARK: Properties
    var placeOfLabel: String?
    var datesOfLabel: String?
    var priceOfLabel: String?
    
    let viewController = UIViewController()
    private var eventService = EventsService()
    private let currentDate = Date().timeIntervalSince1970
    private let placeHolder = UIImage(named: "placeholder")
    private let logoImageView = UIImageView(image: UIImage(named: "bigLogo"))
    private let maxHeaderHeight: CGFloat = 64;
    private let minHeaderHeight: CGFloat = 0;
    private var refreshControl = UIRefreshControl()
    private var previousScrollOffset: CGFloat = 0;
    
    private var loaderView: Loader!
    private var tableViewRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(pullRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    let imageView = UIImageView(image: UIImage(named: "bigLogo"))
     var navBar: UINavigationBar = UINavigationBar()
    
    

    
    
// MARK: EventViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        if Connection.isConnectedToInternet(){
            setupNavigationBar()
            tableView.separatorStyle = .none
            //CustomLoader.instance.showLoader()
            //addRefreshControl()
            prepareRefreshUI()
            eventService.loadEvents(currentDate: currentDate){
                self.tableView.reloadData()
                //CustomLoader.instance.hidesLoader()
            }
        }else{
            
            self.performSegue(withIdentifier: "NoInternet", sender: self)
        }
        
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue , sender: Any?) {
        if segue.identifier == "ShowDetailTable"{
            if let indexPath  = tableView.indexPathForSelectedRow {
                let detailTVController = segue.destination as! DetailTableViewController
                detailTVController.textDet = eventService.listOfFields[indexPath.row].description
                detailTVController.textTitle = eventService.listOfFields[indexPath.row].title
                detailTVController.textBody = eventService.listOfFields[indexPath.row].bodyText
                detailTVController.id = eventService.listOfFields[indexPath.row].id
                detailTVController.textPlace = placeOfLabel
                detailTVController.textDates = datesOfLabel
                detailTVController.textPrice = priceOfLabel
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        placeOfLabel = cell.placeLabel.text
        priceOfLabel = cell.priceLabel.text
        datesOfLabel = cell.dateLabel.text
        performSegue(withIdentifier: "ShowDetailTable", sender: self)
        
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;

        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom

        var newHeightHeader = self.headerHeightConstraint.constant
        if isScrollingDown {
            newHeightHeader = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
        } else if isScrollingUp {
            newHeightHeader = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
        }

        // Header needs to animate
        if newHeightHeader != self.headerHeightConstraint.constant {
            self.headerHeightConstraint.constant = newHeightHeader
            // self.updateHeader()
            self.setScrollPosition(self.previousScrollOffset)
            self.previousScrollOffset = scrollView.contentOffset.y
        }
        
    }
    func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    
    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)
        if self.headerHeightConstraint.constant > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }
    

    
    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            //self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            //self.updateHeader()
            self.view.layoutIfNeeded()
        })
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
    private func addRefreshControl(){
        
        if let objOfRefreshView = Bundle.main.loadNibNamed("Loader", owner: self, options: nil)?.first as? Loader {
            // Initializing the 'refreshView'
            loaderView = objOfRefreshView
            // Giving the frame as per 'tableViewRefreshControl'
            loaderView.frame = tableViewRefreshControl.frame
            // Adding the 'refreshView' to 'tableViewRefreshControl'
            tableViewRefreshControl.addSubview(loaderView)
        }
        
//        refreshControl.addTarget(self, action: #selector(pullRefresh), for: .valueChanged)
//        if #available(iOS 10.0, *){
//            tableView.refreshControl = refreshControl
//        }else{
//            tableView.addSubview(refreshControl)
//        }
        
    }
    
    
    func prepareRefreshUI() {
        // Adding 'tableViewRefreshControl' to tableView
        tableView.refreshControl = tableViewRefreshControl
        // Getting the nib from bundle
       // pullRefresh()
        addRefreshControl()
    }
    
    @objc private func pullRefresh(){
        
        if Connection.isConnectedToInternet(){
            self.loaderView.goRotate()
            eventService.loadEventsAfterPull(currentDate: currentDate){
                self.tableView?.reloadData()
                self.loaderView.stopRotate()
                self.tableViewRefreshControl.endRefreshing()
            }
        }else{
            performSegue(withIdentifier: "NoInternet", sender: self)
        }
        
    }
    
    
    private struct Const {
        static let ImageHeightSizeForSmallState: CGFloat = 32
        static let ImageWidthSizeForSmallState: CGFloat = 77.6
        static let ImageLeftMargin: CGFloat = 16
        static let ImageTopMarginForSmallState: CGFloat = 6
    }
    

    private func setupNavigationBar(){
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        let visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame =  (self.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -10).offsetBy(dx: 0, dy: -10))!
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.addSubview(visualEffectView)
        navigationBar.addSubview(logoImageView)
        navigationBar.setValue(true, forKey: "hidesShadow")
        self.edgesForExtendedLayout = [.left, .bottom, .right, .top]
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.leftAnchor.constraint(equalTo: navigationBar.leftAnchor,
                                             constant: Const.ImageLeftMargin),
            logoImageView.topAnchor.constraint(equalTo: navigationBar.topAnchor,
                                              constant: Const.ImageTopMarginForSmallState),
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

