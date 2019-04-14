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
    
    
    
    func goRotate(){
        loaderImage.isHidden = false
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        loaderImage.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func stopRotate() {
        loaderImage.isHidden = true
        loaderImage.layer.removeAllAnimations()
    }
    
    func hidesLoader() {
        loaderImage.isHidden = true
    }
}
