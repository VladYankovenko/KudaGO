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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        paintHeader()

        // Do any additional setup after loading the view.
    }
    func paintHeader(){
    self.headerView.backgroundColor = UIColor(displayP3Red: 0.89, green: 0.243, blue: 0.224, alpha: 0.96)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
