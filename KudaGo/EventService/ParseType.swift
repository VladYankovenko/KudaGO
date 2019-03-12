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
    
    case events
    case cities
    
    var baseURL: URL {
        return URL(string: "https://kudago.com/public-api/v1.4/")!
    }
    
    var path: String {
        switch self {
        case .events:
           // return "events"
           return "events/?fields=id,dates,title,short_title,slug,place,description,price,is_free"
        case .cities:
            return "locations/?lang=ru"
        }
    }
    
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        
        return URLRequest(url: url!)
    }
    
    
}
