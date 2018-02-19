//
//  HistoryResponseContainer.swift
//  VKApiTest
//
//  Created by Pavel Samsonov on 15/02/2018.
//  Copyright © 2018 Pavel Samsonov. All rights reserved.
//

import UIKit
import ObjectMapper

struct HistoryResponseContainer<T: Mappable>: Mappable {

    var count:  Int?
    var items: [T]?
    var inRead: Int?
    var outRead: Int?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        count           <- map["count"]
        items           <- map["items"]
        inRead          <- map["unread_dialogs"]
        outRead         <- map["unread_dialogs"]
    }
}
