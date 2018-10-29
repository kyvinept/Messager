//
//  ApiManager.swift
//  Messager
//
//  Created by Silchenko on 25.10.2018.
//

import UIKit
import SwiftyJSON

class ApiManager {
    
    private enum Table: String {
        case message = "Message"
        case users = "Users"
    }
    
    private var dataStore: IDataStore?
    private let tableName = "Message"
    private var channel: Channel?
    private var lastMessage: String?
    
    init() { }
    
    func startRealtimeChat(fromUser: User, toUser: User, successBlock: @escaping () -> (), errorBlock: @escaping (Fault?) -> ()) {
        var users = [fromUser.id, toUser.id]
        users.sort()
        users[0].removeSubrange(String.Index(encodedOffset: 22)...String.Index(encodedOffset: users[0].count-1))
        users[1].removeSubrange(String.Index(encodedOffset: 22)...String.Index(encodedOffset: users[1].count-1))
        let idChat = users[0] + users[1]
        channel = Backendless.sharedInstance().messaging.subscribe(idChat)
        channel?.addJoinListener({
            successBlock()
        }, error: { error in
            errorBlock(error)
        })
    }
    
    func addMessageListener(successBlock: @escaping (String?) -> (), errorBlock: @escaping (Fault?) -> ()) {
        channel?.addMessageListenerString({ message in
            if self.lastMessage != message {
                successBlock(message)
            }
        }, error: { error in
            errorBlock(error)
        })
    }
    
    func publishMessage(_ message: Message) {
        var textMessage = ""
        switch message.kind {
        case .text(let text):
            textMessage = text
        default:
            break
        }
        lastMessage = textMessage
        Backendless.sharedInstance().messaging.publish(channel?.channelName, message: textMessage, response: { messageStatus in
            print(messageStatus)
        }, error: { error in
            print("error")
        })
    }
    
    func getUsers(successBlock: @escaping ([User]?) -> (), errorBlock: @escaping (Fault?) -> ()) {
        dataStore = Backendless.sharedInstance()!.data.ofTable(Table.users.rawValue)
        dataStore?.find({ (users) in
           successBlock(self.allUsers(users: users as! [[String : Any]]))
        }, error: { (error) in
            errorBlock(error)
        })
    }
    
    private func allUsers(users: [[String: Any]]) -> [User] {
        var newUsers = [User]()
        for user in users {
            newUsers.append(User(email: user["email"] as! String,
                                  name: user["name"] as! String,
                              password: nil,
                                    id: user["objectId"] as! String,
                             userToken: nil))
        }
        return newUsers
    }
    
//    func saveMessage(fromUser: User, toUser: User, message: Message) {
//        dataStore = Backendless.sharedInstance().data.ofTable(Table.message.rawValue)
//        var textMessage = ""
//        switch message.kind {
//        case .text(let text):
//            textMessage = text
//        default:
//            break
//        }
//        let dataSave = ["Message" : textMessage, "ownerId": fromUser.id, "toUser": toUser.id]
//
//        dataStore?.save(dataSave, response: { savedMessage in
//            print("success")
//        }, error: { fault in
//            print("error")
//        })
//    }
}
