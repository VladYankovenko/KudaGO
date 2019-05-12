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



class ViewController: UIViewController, UITableViewDelegate{
    
// MARK: IBOutlets
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
// MARK: IBActions
    
// MARK: Properties
    
    var events: [Event] = []
    var placeOfLabel: String?
    var datesOfLabel: String?
    var priceOfLabel: String?
    var page = 1
    

    private var jsonParsing = EventManager()
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
    
    
    
    
// MARK: EventViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.separatorStyle = .none
        CustomLoader.instance.showLoader()
        prepareRefreshUI()
        
        jsonParsing.loadEvents(currentDate: currentDate, page: page, completion: { result in
            DispatchQueue.main.async {
                switch result{
                case let .data(eventsFromManager):
                    self.events = eventsFromManager
                    self.tableView.reloadData()
                case .error:
                    self.performSegue(withIdentifier: "NoInternet", sender: self)
                }
                CustomLoader.instance.hidesLoader()
            }
        })
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue , sender: Any?) {
        if segue.identifier == "ShowDetail"{
            if let indexPath  = tableView.indexPathForSelectedRow {
                let eventDetailViewController = segue.destination as! EventDetailViewController
                eventDetailViewController.price = priceOfLabel
                eventDetailViewController.dates = datesOfLabel
                eventDetailViewController.place = placeOfLabel
                eventDetailViewController.event = self.events[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        placeOfLabel = cell.placeLabel.text
        priceOfLabel = cell.priceLabel.text
        datesOfLabel = cell.dateLabel.text
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == events.count - 1{
            page += 1
            jsonParsing.loadEvents(currentDate: currentDate, page: page, completion: { result in
                DispatchQueue.main.async {
                    switch result{
                    case let .data(eventsFromManager):
                        let eventsArray = eventsFromManager
                        for element in 0..<eventsArray.count{
                            self.events.append(eventsArray[element])
                        }
                        self.tableView.reloadData()
                    case .error:
                        self.performSegue(withIdentifier: "NoInternet", sender: self)
                    }
                    
                }
            })
        }
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

        if newHeightHeader != self.headerHeightConstraint.constant {
            self.headerHeightConstraint.constant = newHeightHeader
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
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.view.layoutIfNeeded()
        })
    }
    
   

}

//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
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
            loaderView = objOfRefreshView
            loaderView.hidesLoader()
            loaderView.frame = tableViewRefreshControl.frame
            tableViewRefreshControl.addSubview(loaderView)
        }
    }
    
    
    func prepareRefreshUI() {
        
        tableView.refreshControl = tableViewRefreshControl
        addRefreshControl()
    }
    
    @objc private func pullRefresh(){
        
        self.loaderView.goRotate()
        self.page = 1
        jsonParsing.loadEvents(currentDate: currentDate, page: page) { result in
            DispatchQueue.main.async {
                switch result{
                case let .data(eventsFromManager):
                    self.events = eventsFromManager
                    self.tableView.reloadData()
                    
                case .error:
                    self.performSegue(withIdentifier: "NoInternet", sender: self)
                }
                self.loaderView.stopRotate()
                self.tableViewRefreshControl.endRefreshing()
            }
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
        visualEffectView.frame =  CGRect(origin: CGPoint(x: navigationBar.bounds.origin.x, y: navigationBar.bounds.origin.y - 100), size: CGSize(width: navigationBar.bounds.width, height: navigationBar.bounds.height + 100))
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
        let event = self.events[indexPath.row]
        
        //Load text
        
        cell.titleLabel.text = event.title.uppercased()
        cell.descriptionLabel.text = event.description
        
        //Load place
        
        if let place = event.place?.address{
            cell.placeStackView.isHidden = false
            cell.placeLabel.text = place
        }else{
            cell.placeStackView.isHidden = true
        }
        
        //Load images
        
        let imageURL = event.images[0].thumbnails.pictureSize
        let url = URL(string: imageURL)
        cell.photoEvent.af_setImage(withURL: url!, placeholderImage: placeHolder)
        
        //Load price
        
        if event.price == ""{
            cell.priceLabel.text = "Бесплатно"
        }else{
            cell.priceLabel.text = event.price.capitalized
        }
        
        //Decode and load Date
        
        let dateStart =  Date(timeIntervalSince1970: event.dates[0].start)
        let dateEnd =  Date(timeIntervalSince1970: event.dates[0].end)
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

