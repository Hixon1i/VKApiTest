//
//  APIRouter.swift
//  VKApiTest
//
//  Created by Pavel Samsonov on 15/01/2018.
//  Copyright © 2018 Pavel Samsonov. All rights reserved.
//

import UIKit
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    
    
    static let baseUrl = "https://api.vk.com/method/"
    
    case getDialogs(Int, Int, String), getHistory(String, Int, Int, String)
    
    var path: String {
        
        switch self {
        case .getDialogs(let count, let offset, let token):
            return "messages.getDialogs?count=\(count)&offset=\(offset)&access_token=\(token)"
        case .getHistory(let userID, let count, let offset, let token):
            return "messages.getHistory?user_id=\(userID)&count=\(count)&offset=\(offset)&access_token=\(token)"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    
        
    func asURLRequest() throws -> URLRequest {
        let baseUrl = URL(string: APIRouter.baseUrl)!
        var request = URLRequest(url: baseUrl.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        let encoding = Alamofire.URLEncoding.default
        
        return try encoding.encode(request, with: nil)
    }
    
}
