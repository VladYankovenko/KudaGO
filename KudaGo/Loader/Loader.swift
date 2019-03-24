//
//  Loader.swift
//  KudaGo
//
//  Created by Влад Янковенко on 23.03.2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import UIKit

class Loader: UIView {

    var rotate : CAAnimation?
    @IBOutlet weak var loaderImage: UIImageView!
    
//    func goRotate(){
//        rotate = CABasicAnimation(keyPath: "transform.rotation.z")
//        rotate?.toValue = NSNumber(value: Double.pi * 2)
//        rotate?.duration = 1
//        rotate?.isCumulative = true
//        rotate?.repeatCount = Float.greatestFiniteMagnitude
//        rotate.layer.add(rotation!, forKey: "rotationAnimation")
//        rotate.isHidden = false
//    }
}
