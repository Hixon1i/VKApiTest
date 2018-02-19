//
//  UserResponseContainer.swift
//  VKApiTest
//
//  Created by Pavel Samsonov on 11/02/2018.
//  Copyright © 2018 Pavel Samsonov. All rights reserved.
//

import UIKit
import ObjectMapper

struct UserResponseContainer: Mappable {
    
    var id: Int?
    var firstName: String?
    var lastName: String?
    var photo50: String?
    var verified: Int?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        
        id          <- map["id"]
        firstName   <- map["first_name"]
        lastName    <- map["last_name"]
        photo50     <- map["photo_50"]
        verified    <- map["verified"]
        print("\n MAPPINGS\n \(photo50)")
    }
}
