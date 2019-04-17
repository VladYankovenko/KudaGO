//
//  CustomAnnotationPinMap.swift
//  KudaGo
//
//  Created by Влад Янковенко on 17.04.2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import Foundation
import MapKit


class CustomAnnotationPinMap: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
    }
}
