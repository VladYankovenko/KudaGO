//
//  EventDetailViewController.swift
//  KudaGo
//
//  Created by Влад Янковенко on 13.04.2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController, UIScrollViewDelegate {

    // MARK: IBOutlets
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    
    // MARK: Properties
    
    var place: String?
    var price: String?
    var dates: String?
    var event: Event?
    
    private let placeholder = UIImage(named: "placeholder")
    private var annotationPin: CustomAnnotationPinMap!
    
    // MARK: Actions
    
    @IBAction func backSwipe(_ sender: Any) {
        goBack()
    }
    
    // MARK: Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentEvent()
        drawingEventMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        blurStatusBar()
        createBackButton()
        createPageControl()
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
    
    //MARK: Private functions
    
    private func loadCurrentEvent(){
        bodyTextLabel.text = event?.bodytext
        titleLabel.text = event?.title.uppercased()
        descriptionLabel.text = event?.description
        placeLabel.text = place
        datesLabel.text = dates
        priceLabel.text = price
        
        if let imagesArray = event?.images{
            imageScrollView.delegate = self
            imageScrollView.isPagingEnabled = true
            imageScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(imagesArray.count), height: 260)
            imageScrollView.showsHorizontalScrollIndicator = false
            
            for element in 0..<imagesArray.count{
                var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                frame.origin.x = UIScreen.main.bounds.width * CGFloat(element)
                frame.size = CGSize(width: UIScreen.main.bounds.width, height: 260)
                let imageURL = imagesArray[element].thumbnails.pictureSize
                let url = URL(string: imageURL)
                let imgView = UIImageView(frame: frame)
                imgView.af_setImage(withURL: url!, placeholderImage: placeholder)
                imgView.contentMode = .scaleAspectFill
                imgView.clipsToBounds = true
                imageScrollView.addSubview(imgView)
                
            }
        }
    }
    
    
    //MARK: Design Elements
    
    private func blurStatusBar(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurEffectView)
        blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurEffectView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blurEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    
    
    
    
    private func createBackButton(){
        let backButton = UIButton(type: .custom)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.backgroundColor = .white
        backButton.setImage(UIImage(named: "back"), for: .normal)
        DropShadowEffect.setupProperties(view: backButton, cornerRadius: 16, shadowRadius: 16, widthOffset: 0, heightOffset: 0)
        backButton.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        view.addSubview(backButton)
        if #available(iOS 11.0, *) {
            backButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 9).isActive = true
            backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 7).isActive = true
        } else {
            backButton.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 9).isActive = true
            backButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: 7).isActive = true
        }
        backButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    //MARK: UIPageControl
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let numberOfCurrentPage = Int(imageScrollView.contentOffset.x / imageScrollView.frame.width)
        pageControl.currentPage = numberOfCurrentPage
    }
    
    func createPageControl(){
        pageControl.superview?.bringSubviewToFront(pageControl)
        pageControl.numberOfPages = (event?.images.count)!
    }
    
    
    
    @objc func goBack(){
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: Work with map

extension EventDetailViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotationPin, reuseIdentifier: "Pin")
        annotationView.image = UIImage(named: "pin_map")
        return annotationView
    }
    
    private func drawingEventMap(){
        mapView.delegate = self
        
        if let latitude = event?.place?.coords?.lat, let longitude = event?.place?.coords?.lon{
            let placeCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let pin = CustomAnnotationPinMap(coordinate: placeCoordinates)
            let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
            let region = MKCoordinateRegion(center: placeCoordinates, span: span)
            self.mapView.isScrollEnabled = false
            self.mapView.isRotateEnabled = false
            self.mapView.isZoomEnabled = false
            self.mapView.region = region
            self.mapView.addAnnotation(pin)
            
        }else{
            mapView.isHidden = true
        }
    }
}


