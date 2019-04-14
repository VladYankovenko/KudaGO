//
//  EventDetailViewController.swift
//  KudaGo
//
//  Created by Влад Янковенко on 13.04.2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    
    
    
    // MARK: Properties
    
    let placeholder = UIImage(named: "placeholder")
    var event: Results?
    var place: String?
    var price: String?
    var dates: String?
    var testImages: [UIImage] = [UIImage(named: "EventImageTest")!, UIImage(named: "EventImageTest")!, UIImage(named: "EventImageTest")!, UIImage(named: "EventImageTest")!]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurStatusBar()
        createBackButton()
        loadCurrentEvent()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: Private functions
    
    private func loadCurrentEvent(){
        bodyTextLabel.text = event?.bodytext
        titleLabel.text = event?.title
        descriptionLabel.text = event?.description
        placeLabel.text = place
        datesLabel.text = dates
        priceLabel.text = price
        
        if let imagesArray = event?.images{
            imageScrollView.isPagingEnabled = true
            imageScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(imagesArray.count), height: 260)
            imageScrollView.showsHorizontalScrollIndicator = false
            
            for element in 0..<imagesArray.count{
                var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                frame.origin.x = imageScrollView.frame.size.width * CGFloat(element)
                frame.size = imageScrollView.frame.size
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
        backButton.layer.cornerRadius = 16
        backButton.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        backButton.layer.masksToBounds = false
        backButton.layer.shadowRadius = 16
        backButton.layer.shadowOpacity = 0.3
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
    
    
    
    
    
    @objc func goBack(){
        navigationController?.popViewController(animated: true)
    }
    
}
