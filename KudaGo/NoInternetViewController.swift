//
//  NoInternetViewController.swift
//  KudaGo
//
//  Created by Влад Янковенко on 29.03.2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import UIKit

class NoInternetViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
       // setupTryButton()
        paintHeader()

        // Do any additional setup after loading the view.
    }
    func paintHeader(){
    self.headerView.backgroundColor = UIColor(displayP3Red: 0.89, green: 0.243, blue: 0.224, alpha: 0.96)
    }

//    func setupTryButton(){
//        tryButton.backgroundColor = UIColor(displayP3Red: 0.89, green: 0.243, blue: 0.224, alpha: 0.96)
//        tryButton.layer.cornerRadius = 16
//        tryButton.tintColor = UIColor.white
//        tryButton.target(forAction: #selector(goBack), withSender: self)
//        view.addSubview(tryButton)
//    }
//
//    @objc func goBack(){
//        if Connection.isConnectedToInternet(){
//            navigationController?.popViewController(animated: true)
//        }
//
//    }

}
