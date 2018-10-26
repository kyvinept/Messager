//
//  ApiManager.swift
//  Messager
//
//  Created by Silchenko on 25.10.2018.
//

import UIKit

class ApiManager {
    
    private var dataStore: IDataStore?
    private let tableName = "Message"
    private var channel: Channel?
    private var lastMessage: String?
    
    init() {
        dataStore = Backendless.sharedInstance().data.ofTable(tableName)
    }
    
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
    
//    func saveMessage(fromUser: User, toUser: User, message: Message) {
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
