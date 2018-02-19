//
//  AccessToken.swift
//  VKApiTest
//
//  Created by Pavel Samsonov on 11/01/2018.
//  Copyright © 2018 Pavel Samsonov. All rights reserved.
//

import UIKit
import RealmSwift

class AccessToken: Object {

    @objc dynamic var id = 0
    @objc dynamic var token = String()
    @objc dynamic var expirationDate = Date()
    @objc dynamic var userID = String()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
