//
//  Message.swift
//  VKApiTest
//
//  Created by Pavel Samsonov on 12/01/2018.
//  Copyright © 2018 Pavel Samsonov. All rights reserved.
//

import UIKit

class Message: ServerObject {

    var id: Int?
    var userID: Int?
    var fromID: Int?
    var title: String?
    var body: String?
    
    override func initWithServerResponse(responseObject: NSDictionary) -> Any {
        super.initWithServerResponse(responseObject: responseObject)
        
        if (!self.isEqual(nil)) {
            
            self.id = responseObject.object(forKey: "id") as? Int
            self.userID = responseObject.object(forKey: "user_id") as? Int
            self.fromID = responseObject.object(forKey: "from_id") as? Int
            self.title = responseObject.object(forKey: "title") as? String
            self.body = responseObject.object(forKey: "body") as? String
        }
        
        return self
    }
}
