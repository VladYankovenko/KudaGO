//
//  ImageSize.swift
//  KudaGo
//
//  Created by Влад Янковенко on 16.03.2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import Foundation

struct ImageSize: Decodable {
    let picture: String
    
    enum CodingKeys: String, CodingKey {
        case picture = "640x384"
    }
}
