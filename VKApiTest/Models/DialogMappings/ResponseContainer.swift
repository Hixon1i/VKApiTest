//
//  ResponseContainer.swift
//  VKApiTest
//
//  Created by Pavel Samsonov on 20/01/2018.
//  Copyright © 2018 Pavel Samsonov. All rights reserved.
//

import UIKit
import ObjectMapper

struct ResponseContainer<T : Mappable> : Mappable {
    
    var count:  Int?
    var unreadDialogs: Int?
    var items: [T]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        count         <- map["count"]
        unreadDialogs <- map["unread_dialogs"]
        items         <- map["items"]
    }
}
