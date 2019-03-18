//
//  Result.swift
//  tableView11
//
//  Created by Влад on 04/03/2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import Foundation


struct Result: Decodable {
    let id: Int
    let title: String
    let slug: String
    let description: String
    let price: String
    let place: Place?
    let images: [Images]
    let dates: [Dates]
    
    
    enum CodingKeys: String, CodingKey {
        case id, title, slug, description, price, place, images, dates
    }
    
    
    init(id: Int, title: String, slug: String, description: String, price: String, place: Place?, images: [Images], dates: [Dates]) {
        self.id = id
        self.title = title
        self.slug = slug
        self.description = description
        self.price = price
        self.place = place
        self.images = images
        self.dates = dates
    }
}