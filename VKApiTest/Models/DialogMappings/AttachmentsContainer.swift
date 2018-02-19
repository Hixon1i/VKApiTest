//
//  AttachmentsContainer.swift
//  VKApiTest
//
//  Created by Pavel Samsonov on 23/01/2018.
//  Copyright © 2018 Pavel Samsonov. All rights reserved.
//

import UIKit
import ObjectMapper

struct AttachmentsContainer: Mappable {
    
    var type: String?
    var attachment: Any?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        
        type        <- map["type"]
        attachment  <- map["attachment"]
    }
}
