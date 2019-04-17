//
//  CustomLoader.swift
//
//
//  Created by Влад Янковенко on 30.03.2019.
//

import UIKit

class CustomLoader: UIView {
    static let instance = CustomLoader()

    lazy var fullView: UIView = {
        let fullView  = UIView(frame: UIScreen.main.bounds)
        fullView.backgroundColor = UIColor.white
        fullView.isUserInteractionEnabled = false
        return fullView
    }()
    
    
    lazy var loader: UIView = {
        let loader  = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        loader.center = fullView.center
        loader.isUserInteractionEnabled = false
        loader.image = UIImage(named: "loader")
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        loader.layer.add(rotation, forKey: "rotationAnimation")
        return loader
    }()
    
    func showLoader() {
        self.addSubview(fullView)
        self.fullView.addSubview(loader)
        self.fullView.bringSubviewToFront(self.loader)
        UIApplication.shared.keyWindow?.addSubview(fullView)
    }
    
    func hidesLoader(){
        self.fullView.removeFromSuperview()
    }
}
