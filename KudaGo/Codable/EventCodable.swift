//
//  EventCodable.swift
//  KudaGo
//
//  Created by Влад Янковенко on 04.04.2019.
//  Copyright © 2019 Влад. All rights reserved.

import UIKit

struct Results: Codable{
    let id: Int?
    struct Dates: Codable {
        let start: Double
        let end: Double
    }
    let dates: [Dates]
    let title: String
    struct Place: Codable {
        let address: String?
        struct Coords: Codable {
            let lat: Double?
            let lon: Double?
        }
        let coords: Coords?
    }
    let place: Place?
    let description: String
    let bodytext: String
    let price: String
    struct Image: Codable {
        let image: String
        struct Size: Codable {
            let pictureSize: String
            enum CodingKeys: String, CodingKey {
                case pictureSize = "640x384"
            }
        }
        let thumbnails: Size
        init(image: String, thumbnails: Size) {
            self.image = image
            self.thumbnails = thumbnails
        }
    }
    let images: [Image]
    
    enum CodingKeys: String, CodingKey {
        case id, dates,title, place, description, price, images
        case bodytext = "body_text"
    }
    
   init(id: Int?, dates: [Dates], title: String, place: Place?, description: String, bodytext: String, price: String, images: [Image]) {
        self.id = id
        self.dates = dates
        self.title = title
        self.place = place
        self.description = description
        self.bodytext = bodytext
        self.price = price
        self.images = images
    }
}


struct Event: Codable {
    let results: [Results]
}
