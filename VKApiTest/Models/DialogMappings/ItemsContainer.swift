//
//  ItemsContainer.swift
//  VKApiTest
//
//  Created by Pavel Samsonov on 20/01/2018.
//  Copyright © 2018 Pavel Samsonov. All rights reserved.
//

import UIKit
import ObjectMapper

struct ItemsContainer<T : Mappable> : Mappable {
    
    var inRead:   String?
    var outRead:  String?
    var unread:   Int?
    var message: T?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        
        
        inRead    <- map["in_read"]
        outRead   <- map["out_read"]
        unread    <- map["unread"]
        message   <- map["message"]
    }
}
