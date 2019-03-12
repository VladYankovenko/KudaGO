//
//  ShadowView.swift
//  tableView11
//
//  Created by Влад on 18/02/2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    private func setupShadow() {
        
        DropShadowEffect.setupProperties(view: self, cornerRadius: 16, shadowRadius: 12, widthOffset: 0, heightOffset: 0)
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 16).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
}
