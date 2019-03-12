//
//  TableViewCell.swift
//  tableView11
//
//  Created by Влад on 17/02/2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var photoEvent: UIImageView!
    
    @IBOutlet weak var viewRounded: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      // shadodAdd()
        setupShadow()
        viewRounded.layer.masksToBounds = true
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
    
    //УДАЛИТЬ НЕ НУЖНА
    func shadodAdd() {
        shadowView.layer.cornerRadius = 30
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.shadowRadius = 20
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        shadowView.layer.shouldRasterize = true
    }
    
    private func setupShadow() {
        
        DropShadowEffect.setupProperties(view: self, cornerRadius: 20, shadowRadius: 20, widthOffset: 0, heightOffset: 2)
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 20).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }

}
