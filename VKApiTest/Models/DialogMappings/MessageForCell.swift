//
//  MessageForCell.swift
//  VKApiTest
//
//  Created by Pavel Samsonov on 15/01/2018.
//  Copyright © 2018 Pavel Samsonov. All rights reserved.
//

import UIKit
import ObjectMapper

class TransformUrls: TransformType {

    typealias Object = String
    typealias JSON   = AnyObject
    
    let key: String
    
    init(key: String) {
        self.key = key
    }
    
    func transformFromJSON(_ value: Any?) -> String? {
        guard let array = value as? Array<[String:String]> else { return nil }
        
        for elem in array {
            if elem["type"] == key {
                return elem["url"]
            }
        }
        return nil
    }
    
    func transformToJSON(_ value: String?) -> AnyObject? {
        return nil
    }
}

struct MessageForCell<T : Mappable> : Mappable {
    
    var id:             Int?
    var date:           TimeInterval?
    var out:            Bool?
    var userID:         Int?
    var readState:      Bool?
    var title:          String?
    var body:           String?
    var emoji:          NSInteger?
    var chatId:         Int?
    var chatActive:     [Int]?
    var pushSettings:   Any?
    var usersCount:     Int?
    var adminId:        Int?
    var photo50:        String?
    var photo100:       String?
    var photo200:       String?
    var attachments:    [T]?
    
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        
        id              <- map["id"]
        date            <- map["date"]
        out             <- map["out"]
        userID          <- map["user_id"]
        readState       <- map["read_state"]
        title           <- map["title"]
        body            <- map["body"]
        emoji           <- map["emoji"]
        chatId          <- map["chat_id"]
        chatActive      <- map["chat_active"]
        pushSettings    <- map["push_settings"]
        usersCount      <- map["users_count"]
        adminId         <- map["admin_id"]
        photo50         <- map["photo_50"]
        photo100        <- map["photo_100"]
        photo200        <- map["photo_200"]
        attachments     <- map["attachments"]
    }
}
