//
//  EventsService.swift
//  tableView11
//
//  Created by Влад on 01/03/2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import UIKit

class EventsService {
    var listOfFields = [Result]()
    
    func jsonTaskWith(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        var request = request
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let HTTPResponse = response as? HTTPURLResponse else {
                let userInfo = [ NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "") ]
                let error = NSError(domain: "", code: 0, userInfo: userInfo)
                completionHandler(nil, nil, error)
                return
            }
            if data == nil {
                if let error = error {
                    completionHandler(nil, HTTPResponse, error)
                }
            } else {
                completionHandler(data, HTTPResponse, nil)
            }
        }
        task.resume()
    }
    
    
    
    private lazy var session: URLSession = URLSession.shared
    
   /* func loadEvents(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard  let url = URL(string: "https://kudago.com/public-api/v1.4/events/")  else {
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            //print(data)
            do{
                guard let data = data else{
                    return
                }
                guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as?[String: Any] else{
                    return
                }
                let resultDictionary = dictionary["results"]
                guard let results = try? JSONSerialization.data(withJSONObject: resultDictionary, options: JSONSerialization.WritingOptions.prettyPrinted) else {
                    return
                }
                let events = try JSONDecoder().decode(Events.self, from: data)
                //print(dictionary)
                self.parseEvents(array: events)
                
                
                //print("#########",eventJSON)
                
               // print(events!)
            }catch{
                print(error)
            }
        }
        task.resume()
    }
 */
    
    func loadEvents(completion: @escaping() -> ()) {
        
        let request = ParseType.events.request
        
        jsonTaskWith(request: request) { (data, request, error) in
            
            guard let data = data else { return }
            do {
                let eventJSON = try JSONDecoder().decode(Events.self, from: data)
                self.parseEvents(array: eventJSON)
                //print("#########",eventJSON)
                DispatchQueue.main.async {
                    completion()
                }
            } catch let jsonErr as NSError {
                print ("error:", jsonErr)
            }
        }
    }
    
    private func parseEvents(array: Events ) {
        
        for eachElement in array.results {
            let id = eachElement.id
            let title = eachElement.title
            let slug = eachElement.slug
            let description = eachElement.description
            let price = eachElement.price
        
            self.listOfFields.append(Result(id: id,title: title, slug: slug, description: description, price: price ))
           print(listOfFields)
        }
        
    }
}
