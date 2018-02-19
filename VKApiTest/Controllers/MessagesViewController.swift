//
//  MessagesViewController.swift
//  VKApiTest
//
//  Created by Pavel Samsonov on 28/01/2018.
//  Copyright © 2018 Pavel Samsonov. All rights reserved.
//

import UIKit
import RealmSwift

class MessagesViewController: UIViewController {

    let realm = try! Realm()
    lazy var dataSource: Results<AccessToken> = {
        
        return self.realm.objects(AccessToken.self)
    }()
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textBarView: UIView!
    
    var userID = 0
    var token: AccessToken!
    var messages = [HistoryItemsContainer<HistoryAttachmentsContainer>]()
    
    var loadMoreStatus = true
    var refreshStatus = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userID)
        
        token = dataSource[0]
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func send(_ sender: UIButton) {
        
        print("Something goes wrong...")
    }
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if (messages[indexPath.row].fromID == messages[indexPath.row].userID) {
            
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "CurrentUserTableViewCell", for: indexPath) as! CurrentUserTableViewCell
            
            currentCell.configure(text: messages[indexPath.row].body!)
            cell = currentCell
        } else {
            
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "AnotherUserTableViewCell", for: indexPath) as! AnotherUserTableViewCell
            currentCell.configure(text: messages[indexPath.row].body!)
            cell = currentCell
        }
        
        return cell
    }
}

extension MessagesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height < self.messagesTableView.frame.size.height ?
                                                            self.messagesTableView.frame.size.height :
                                                            scrollView.contentSize.height
        
        let maxHeight = contentHeight - (self.messagesTableView.frame.size.height)
        loadMoreStatus = offsetY < maxHeight ? false : loadMoreStatus
        refreshStatus = offsetY < (-64) ? refreshStatus : false
        
//        if offsetY > maxHeight && !loadMoreStatus && !isLoading {
//
//            loadMoreStatus = true
//            isLoading = true
//
//            print("\(loadMoreStatus.description)\n\n")
//
//            limit += 20
//            print(limit)
//
//            self.loadData()
//
//            print("------>>>>>>")
//        }
        
        if offsetY < (-64) && !refreshStatus {
            
            refreshStatus = true
            
            print("=====>>>>>")
            
//            limit = 20
            self.loadData()
        }
    }
}

extension MessagesViewController {
    
    func loadData() {
        
        let apiConnetion = ApiConnection()
        
        apiConnetion.getHistory(id: userID,
                                count: 20,
                                offset: 0,
                                token: token.token,
                                completionHandler: { ( response ) in
                                    
                                    if (response != nil) {
                                        
                                        self.messages = response!
                                        self.messagesTableView.reloadData()
//                                        print(response?.description)
                                    }
                                    print("response: \(response)")
                               },
                                failure: { ( error ) in
                                    print(error?.localizedDescription)
                               })
        print("LOADDATA")
    }
}
















