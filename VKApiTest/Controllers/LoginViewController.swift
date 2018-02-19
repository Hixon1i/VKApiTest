//
//  LoginViewController.swift
//  VKApiTest
//
//  Created by Pavel Samsonov on 11/01/2018.
//  Copyright © 2018 Pavel Samsonov. All rights reserved.
//

import UIKit
import Alamofire
import WebKit
import RealmSwift

typealias loginCompletionBlock = (_ token: AccessToken) -> Void

class LoginViewController: UIViewController, WKNavigationDelegate {

    let realm = try! Realm()
    lazy var dataSource: Results<AccessToken> = {
        
        return self.realm.objects(AccessToken.self)
    }()
    
    @IBOutlet weak var loginWebView: WKWebView!
    
    var completionBlock: ((_ token: AccessToken) -> Void)?
    var token = AccessToken()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://oauth.vk.com/authorize?client_id=6329975&scope=143382&redirect_uri=https://oauth.vk.com/blank.html&display=mobile&v=5.69&response_type=token"
        // + 2 + 4 + 16 + 131072 + 8192 + 4096
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        
        self.loginWebView.navigationDelegate = self
        
        self.loginWebView.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
     
        var r = self.view.bounds
        r.origin = CGPoint(x: 0.0, y: 0.0)
        
        loginWebView.frame = r
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        decisionHandler(WKNavigationActionPolicy.allow)
        let request = navigationAction.request
        let str = navigationAction.request.url?.description
        print(String(describing: str))
        
        print(request.url?.host!)
        
        if (request.url?.host == "oauth.vk.com") {
            
            var query = request.url?.description
            let array = query?.components(separatedBy: "#")
            print(array)
            
            if ((array?.count)! > 1) {
                
                query = array?.last!
            }
            
            let pairs = query?.components(separatedBy: "&")
//            var pair = String()
            
            for pair in pairs! {
                
                let values = pair.components(separatedBy: "=")
                
                if (values.count == 2) {
                    
                    let key = values.first
                    
                    if (key == "access_token") {
                        
                        token.token = values.last!
                    } else if (key == "expires_in") {
                        
                        if let interval = Double(values.last!) {
                            
                            token.expirationDate = Date(timeIntervalSinceNow: interval)
                        }
                    } else if (key == "user_id") {
                        
                        token.userID  = values.last!
                    }
                }
            }
            
//            self.loginWebView.navigationDelegate = nil
            
            if ((completionBlock) != nil) {
                
                completionBlock!(token)
            }
            token.id = 0
            saveToken(tokenToSave: token)
            print("\n\(token.token)\n\(token.expirationDate)\n\(token.userID)")
        }
    }
}

extension LoginViewController {
    
    func saveToken(tokenToSave: AccessToken) {
        
        if (tokenToSave.token != "" && tokenToSave.userID != "") {
            
            let tempToken = tokenToSave
            
            do {
                
                try realm.write {
                    realm.add(tempToken, update: true)
                }
            } catch {
                
                print("ERRoR")
            }
        } else {
            
            print("123")
        }
    }
    
}













