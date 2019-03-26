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
    var textTitle: String?
    var textBody: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableOptions()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        createBackButton()
        blurStatusBar()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @objc func goBack() {
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
        cell.titleLabel.text = textTitle?.uppercased()
        cell.bodyLable.text = textBody
        
        return cell
    }
    
    
    func setTableOptions(){
        self.tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        tableView?.estimatedRowHeight = 231
        tableView?.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
    }
    
    func blurStatusBar(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurEffectView)
        blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurEffectView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blurEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    func createBackButton(){
        //let backButton = UIButton(frame: CGRect(x: 9, y: 27, width: 48, height: 32))
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
        backButton.layer.shadowOpacity = 0.1
        view.addSubview(backButton)
        if #available(iOS 11.0, *) {
            backButton.leadingAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.leadingAnchor, constant: 9).isActive = true
            backButton.topAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.topAnchor, constant: 7).isActive = true
        } else {
            backButton.leadingAnchor.constraint(equalTo: tableView.layoutMarginsGuide.leadingAnchor, constant: 9).isActive = true
            backButton.topAnchor.constraint(equalTo: tableView.layoutMarginsGuide.bottomAnchor, constant: 7).isActive = true
        }
        backButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
}


