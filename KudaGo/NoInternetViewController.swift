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
        paintHeader()
    }
    
    
    func paintHeader(){
        self.headerView.backgroundColor = UIColor(displayP3Red: 0.89, green: 0.243, blue: 0.224, alpha: 0.96)
    }
    
}
