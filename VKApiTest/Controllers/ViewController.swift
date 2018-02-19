
//  ViewController.swift
//  VKApiTest
//
//  Created by Pavel Samsonov on 11/01/2018.
//  Copyright © 2018 Pavel Samsonov. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var dialogsListTableView: UITableView!
    //bundle : com.samsonovpavel.home.VKApiTest
    
    let realm = try! Realm()
    lazy var dataSource: Results<AccessToken> = {
        
        return self.realm.objects(AccessToken.self)
    }()
    
    var messages = [MessageForCell<AttachmentsContainer>]()
    var userIds = [Int]()
    var users: [UserResponseContainer]?
    var token = AccessToken()
    
    var selectedRow = 0
    var userID = 0
    var isChat = false
    var limit = 20
    var offset = 0
    var loadMoreStatus = true
    var refreshStatus = true
    var isLoading = false
    
    //https://api.vk.com/method/METHOD_NAME?PARAMETERS&access_token=ACCESS_TOKEN&v=V
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let valueNib = UINib(nibName: "DialogTableViewCell", bundle: nil)
        dialogsListTableView.register(valueNib, forCellReuseIdentifier: "DialogTableViewCell")
        
        let reloadBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh,
                            target: self,
                            action: #selector(ViewController.reload))
        self.navigationItem.leftBarButtonItem = reloadBarButtonItem
        
        getToken()
        
        dialogsListTableView.estimatedRowHeight = 60.0
        dialogsListTableView.rowHeight = 60.0
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showAlert()
        getToken()
        responseDidAppear()
        print(messages.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getToken() {
        
        if (!dataSource.isEmpty) {
            
            token.token = dataSource[0].token
            token.expirationDate = dataSource[0].expirationDate
            token.userID = dataSource[0].userID
        }
        
    }

    @objc func reload() {
        
        showAlert()
        responseDidAppear()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DialogTableViewCell", for: indexPath) as! DialogTableViewCell
        
        print("messages.count = \(messages.count)")
        print("users.count = \(users?.count)")
        
        if (users?.count != messages.count) {
            
            responseDidAppear()
        } else {
            
            var configMessageStr = ""
            var configTitleStr = ""
            if (messages[indexPath.row].body == "") {
                
                switch messages[indexPath.row].attachments?.first?.type {
                case "photo"?:
                    configMessageStr = "Фотография"
                case "video"?:
                    configMessageStr = "Видеозапись"
                case "audio"?:
                    configMessageStr = "Аудиозапись"
                case "audio_message"?:
                    configMessageStr = "Аудиосообщение"
                case "doc"?:
                    configMessageStr = "Документ"
                case "link"?:
                    configMessageStr = "Ссылка"
                case "market"?:
                    configMessageStr = "Товар"
                case "market_album"?:
                    configMessageStr = "Подборка товаров"
                case "wall"?:
                    configMessageStr = "Запись на стене"
                case "wall_reply"?:
                    configMessageStr = "Ответ на стене"
                case "sticker"?:
                    configMessageStr = "Стикер"
                case "graffity"?:
                    configMessageStr = "Граффити"
                default:
                    configMessageStr = "Вложение"
                }
                
                cell.messageLabel.textColor = .blue
            } else {
                
                configMessageStr = (messages[indexPath.row].body?.description)!
                cell.messageLabel.textColor = .gray
            }
            
            if (messages[indexPath.row].title! == "" && messages[indexPath.row].userID! > 0) {
                
                //            print(userIds)
                
                if (users != nil) {
                    
                    //                print(indexPath.row)
                    //                print(userIds.count)
                    //                print("\(limit)  \(offset)")
                    
                    let firstName = users![indexPath.row].firstName
                    let lastName = users![indexPath.row].lastName
                    
                    print("111--111")
                    configTitleStr = firstName! + " " + lastName!
                    
                    if (users?[indexPath.row].photo50 != nil) {
                        
                        let url = URL(string: (users?[indexPath.row].photo50)!)
                        cell.userImage.kf.setImage(with: url)
                    }
                }
            } else {
                
                configTitleStr = messages[indexPath.row].title!
                cell.userImage.image = nil
            }
            
            cell.titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            cell.messageLabel.font = UIFont.systemFont(ofSize: 14)
            cell.configure(title: configTitleStr, message: configMessageStr)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedRow = indexPath.row
        
        if (self.messages[indexPath.row].title == "") {
            
            isChat = true
            userID = self.messages[indexPath.row].userID!
        } else {
            
            isChat = false
            userID = self.messages[indexPath.row].chatId!
        }
        
        print(messages.count)
        showMessages()
    }
    
    
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        guard let collectionView = self.dialogsListTableView else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height < self.dialogsListTableView.frame.size.height ?
                                                            self.dialogsListTableView.frame.size.height :
                                                            scrollView.contentSize.height
        
        let maxHeight = contentHeight - (self.dialogsListTableView.frame.size.height)
        loadMoreStatus = offsetY < maxHeight ? false : loadMoreStatus
        refreshStatus = offsetY < (-64) ? refreshStatus : false
        

//        print(loadMoreStatus.description)
        
        if offsetY > maxHeight && !loadMoreStatus && !isLoading {
            
            loadMoreStatus = true
            isLoading = true
            
            print("\(loadMoreStatus.description)\n\n")
            
            limit += 20
            print(limit)
//            offset += 20
            
            self.responseDidAppear()
            
            print("------>>>>>>")
        }
        
        if offsetY < (-64) && !refreshStatus {
            
            refreshStatus = true
            
            limit = 20
            self.responseDidAppear()
        }
    }
}

extension ViewController {
    
    func loadData() {
        
        let apiConnect = ApiConnection()
        
        apiConnect.getDialogs(limit, offset: offset, token: token.token, completionHandler: { ( message ) in
            
            if let tempMessages = message {
                print("---------->>>")
                
//                var tempArray = self.messages
//
//                for i in 0...(tempMessages.count - 1) {
//
//                    tempArray.append(tempMessages[i])
//                }
                
                self.messages = tempMessages
            
                var tempID = 1
                var tempIDS = [Int]()
                
                for i in 0...(tempMessages.count - 1) {
                    
                    if (tempMessages[i].title! == "" && tempMessages[i].userID! > 0) {
                        
                        tempIDS.append(tempMessages[i].userID!)
                    } else {
                        tempIDS.append(tempID)
                        tempID += 1
                    }
                }
                self.userIds = tempIDS
            }
            
        }) { ( error ) in
            
            print("\nERRoR: \(String(describing: error?.localizedDescription))")
        }
    }
    
    func loadUser(id: [Int]) {
        
        let apiConnect = ApiConnection()
        
        apiConnect.getUsers(id: id, token: token.token, completionHandler: { ( response ) in
            
            if let responseT = response {
                
                self.users = responseT
                self.dialogsListTableView.reloadData()
            }
            self.isLoading = false
        }) { ( error ) in
            print(error?.localizedDescription)
        }
    }
    
    func responseDidAppear() {
        
        loadData()
        loadUser(id: userIds)
        print(users?[0].photo50)
    }
}

extension ViewController {
    
    func showAlert() {
        
        let expirationDate = self.token.expirationDate
        
        
        let time = Date().timeIntervalSinceReferenceDate
        let currentDate = Date(timeIntervalSinceNow: 0)
        
        print(expirationDate)
        print(currentDate)
        
        if (expirationDate < currentDate) {
            
            let alert = UIAlertController(title: "Login", message: "You have to login to see your dialogs", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ViewController {
    
}

extension ViewController {
    
    func showMessages() {
        print(userID)
        
        let messagesVC = storyboard?.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
        messagesVC.userID = userID
        self.navigationController?.pushViewController(messagesVC, animated: true)
    }
    
    func myFunc(completion: (_ userID: Int, _ isChat: Bool) -> Void){
        
        completion(userID, isChat)
    }
}
















