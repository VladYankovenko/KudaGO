//
//  DetailTVCell.swift
//  KudaGo
//
//  Created by Влад Янковенко on 21.03.2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import UIKit

class DetailTVCell: UITableViewCell {
    
    
    @IBOutlet weak var descLable: UILabel!
    @IBOutlet weak var bodyLable: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
