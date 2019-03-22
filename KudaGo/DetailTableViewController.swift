//
//  DetailTableViewController.swift
//  KudaGo
//
//  Created by Влад Янковенко on 21.03.2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController{
var textDet: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
    }

    @IBAction func goBack(_ sender: Any) {
        print("345")
        navigationController?.popViewController(animated: true)
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! DetailTVCell
        
       cell.descLable.text = textDet
        
        return cell
    }
    
    //MARK: Customize NavBar
    
//    private func Customization(){
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: , target: self, action: <#T##Selector?#>)
//    }
    


}


