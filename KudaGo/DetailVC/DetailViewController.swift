//
//  DetailViewController.swift
//  KudaGo
//
//  Created by Влад Янковенко on 19.03.2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var text: String?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var eventService = EventsService()
    private let currentDate = Date().timeIntervalSince1970
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //titleLabel.text = eventService.listOfFields[0].title
       // descriptionLabel.text = eventService.listOfFields[myIndex].description
        eventService.loadEvents(currentDate: currentDate, completion: {
            self.titleLabel.text = self.text
            self.descriptionLabel.text = self.eventService.listOfFields[myIndex].description
            })

        // Do any additional setup after loading the view.
       // print(eventService.listOfFields)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
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
