//
//  DetailTVCell.swift
//  KudaGo
//
//  Created by Влад Янковенко on 21.03.2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import UIKit

class DetailTVCell: UITableViewCell {
    
    
    @IBOutlet weak var collectionViewDetail: UICollectionView!
    @IBOutlet weak var descLable: UILabel!
    @IBOutlet weak var bodyLable: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var DetailImageView: UIImageView!
    @IBOutlet weak var DetailScrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension DetailTVCell{
    func setCollectionViewDataSourseDelegate
        <D: UICollectionViewDelegate & UICollectionViewDataSource>
        (_ dataSourseDelegate: D, forRow row: Int)
    {
        collectionViewDetail.delegate = dataSourseDelegate
        collectionViewDetail.dataSource = dataSourseDelegate
        
        collectionViewDetail.reloadData()
    }
}


