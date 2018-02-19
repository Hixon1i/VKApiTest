//
//  DataContaner.swift
//  VKApiTest
//
//  Created by Pavel Samsonov on 20/01/2018.
//  Copyright © 2018 Pavel Samsonov. All rights reserved.
//

import UIKit
import ObjectMapper

struct DataContaner<T : Mappable> : Mappable {
    
    var response: T?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        
        response <- map["response"]
    }
}
