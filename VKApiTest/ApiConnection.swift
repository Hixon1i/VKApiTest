//
//  ApiConnection.swift
//  VKApiTest
//
//  Created by Pavel Samsonov on 15/01/2018.
//  Copyright © 2018 Pavel Samsonov. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class ApiConnection: NSObject {

    let baseUrl = "https://api.vk.com/method/"
    
    let sessionManager: Alamofire.SessionManager
    
    override init() {
        let configuration = URLSessionConfiguration.default
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
}

extension ApiConnection {
    
    func getDialogs(_ count: Int,
                    offset: Int,
                    token: String,
                    completionHandler: @escaping (_ messages: [MessageForCell<AttachmentsContainer>]?) -> Void,
                    failure: @escaping (_ error : Error?) -> Void) {

        let request = APIRouter.asURLRequest(APIRouter.getDialogs(count, offset, token))
        let url = baseUrl + "messages.getDialogs?count=\(count)&offset=\(offset)&access_token=\(token)&v=5.71"
        
        
        _ = ApiConnection().sessionManager
        
        Alamofire.request(url, method: .get)
            .responseObject { (response: DataResponse<DataContaner<ResponseContainer<ItemsContainer<MessageForCell<AttachmentsContainer>>>>>) in
            
//                print("\n\(String(describing: response.result.value?.response?.items))")
            
            var messagesArray = [MessageForCell<AttachmentsContainer>]()
            messagesArray.removeAll()
            
            for var i in 0...(count - 1) {
                
                    guard let itemObj = response.result.value?.response?.items?[i] else { return }
                    messagesArray.append(itemObj.message!)
            }
            
            if (response.result.value?.response?.items) != nil {
                
                completionHandler(messagesArray)
//                print(messagesArray)
            } else {
                failure(response.result.error)
            }
        }
    }
    
    func getUsers(id: [Int],
                  token: String,
                  completionHandler: @escaping (_ users: [UserResponseContainer]?) -> Void,
                  failure: @escaping (_ error : Error?) -> Void) {
        
        //https://api.vk.com/method/METHOD_NAME?PARAMETERS&access_token=ACCESS_TOKEN&v=V
        
        let currentUrl = baseUrl + "users.get?access_token=\(token)"

        let params = ["user_ids": id,
                      "fields": "photo_50,verified"] as [String: Any]
        
        Alamofire.request(currentUrl, method: .get, parameters: params)
            .responseObject { (response: DataResponse<UserDataContainer<UserResponseContainer>>) in
            
                guard let users = response.result.value?.response else { return }
                
                print("\n\n\(users.description)")
                
                if (users.isEmpty) {
                    
                    failure(response.result.error)
                } else {
                    
                    completionHandler(users)
                }
                
        }
    }
    
    func getHistory(id: Int,
                    count: Int,
                    offset: Int,
                    token: String,
                    completionHandler: @escaping (_ messages: [HistoryItemsContainer<HistoryAttachmentsContainer>]?) -> Void,
                    failure: @escaping (_ error : Error?) -> Void) {
        
        //https://api.vk.com/method/METHOD_NAME?PARAMETERS&access_token=ACCESS_TOKEN&v=V
        
        let currentUrl = baseUrl + "messages.getHistory?"
        let idStr = String(id)
        
        let params = ["count": 1,
                      "offset": offset,
                      "user_id": idStr,
                      "access_token": token] as [String: Any]
        
        Alamofire.request(currentUrl, method: .post, parameters: params)
            .responseObject { ( response: DataResponse<HistoryDataContainer<HistoryResponseContainer<HistoryItemsContainer<HistoryAttachmentsContainer>>>>) in
            
                guard let messages = response.result.value?.response?.items else { return }
                
                print("MESSAGES \n \(messages)")
                
                if (messages.isEmpty) {
                    
                    failure(response.result.error)
                } else {
                    completionHandler(messages)
                }
        }
    }
}











