//
//  JsonParsing.swift
//  KudaGo
//
//  Created by Влад Янковенко on 04.04.2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import UIKit

class EventManager {
    
    enum Result<ResultDataType> {
        case data(ResultDataType)
        case error
    }
    
    func loadEvents(currentDate: Double, page: Int, completion: @escaping(Result<[Event]>) -> Void)  {
        let urlString = "https://kudago.com/public-api/v1.4/events/?location=msk&fields=id,title,dates,place,short_title,slug,description,price,images,place,body_text&expand=place,images&page=\(page)&actual_since=\(currentDate)&text_format=text&order_by=-publication_date"
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                let jsonData = try? JSONDecoder().decode(getEvent.self, from: data) else{
                    completion(.error)
                    return
            }
            completion(.data(jsonData.results))
            }.resume()
    }
}
