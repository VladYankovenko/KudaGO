//
//  ParseType.swift
//  tableView11
//
//  Created by Влад on 04/03/2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import UIKit

protocol URLPoint {
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
    
}

enum ParseType: URLPoint {
    
    case events(currentDate: Double)
    case cities
    
    var baseURL: URL {
        return URL(string: "https://kudago.com/public-api/v1.4/")!
    }
    
    var path: String {
        switch self {
        case .events(let currentDate):
           // return "events"
           return "events/?location=msk&fields=id,title,dates,place,short_title,slug,description,price,is_free,place&expand=place&actual_since=\(currentDate)&text_format=text&order_by=-publication_date"
            
        case .cities:
            return "locations/?lang=ru"
        }
    }
    //actual_since=\(currentDate)&
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        
        return URLRequest(url: url!)
    }
    
    
}
