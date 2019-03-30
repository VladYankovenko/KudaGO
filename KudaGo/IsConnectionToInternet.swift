//
//  IsConnectionToInternet.swift
//  KudaGo
//
//  Created by Влад Янковенко on 29.03.2019.
//  Copyright © 2019 Влад. All rights reserved.
//

import Foundation
import Alamofire

class Connection {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
