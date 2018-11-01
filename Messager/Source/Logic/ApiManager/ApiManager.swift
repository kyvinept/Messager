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
    
    private var mapper: Mapper
    private var dataStore: IDataStore?
    private let tableName = "Message"
    private var channel: Channel?
    private var imageManager: ImageManager
    private var databaseManager: DatabaseManager
    
    init(mapper: Mapper, imageManager: ImageManager, databaseManager: DatabaseManager) {
        self.mapper = mapper
        self.imageManager = imageManager
        self.databaseManager = databaseManager
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
    
    func addMessageListener(successBlock: @escaping (Message?) -> (), errorBlock: @escaping (Fault?) -> ()) {
        channel?.addMessageListenerDictionary({ dictionary in
            guard let dictionary = dictionary as? [String: Any] else { return }
            var message = self.mapper.map(message: dictionary)
            
            if let text = dictionary[MessageType.text.rawValue] as? String {
                message.kind = MessageKind.text(text)
                successBlock(message)
            } else if let url = dictionary[MessageType.image.rawValue] as? String {
                self.imageManager.downloadImage(url: url,
                                           progress: { (progress) in
                                                         print(progress)
                                                     },
                                  completionHandler: { messageKind in
                                                         if let messageKind = messageKind {
                                                            message.kind = messageKind
                                                            successBlock(message)
                                                         }
                                                     })
            }
        }, error: { error in
            print("error")
        })
    }
    
    func publishMessage(_ message: Message) {
        var request: [String: Any] = ["sentDate": message.sentDate.toString(),
                                      "messageId": message.messageId,
                                      "sender": ["id": message.sender.id,
                                                 "email": message.sender.email,
                                                 "name": message.sender.name]]
        
        switch message.kind {
        case .text(let text):
            request[MessageType.text.rawValue] = text
            self.sendMessage(message: request)
        case .photo(let mediaItem):
            if let data = UIImageJPEGRepresentation(mediaItem.image, 0.1) {
                imageManager.uploadImage(data: data,
                                     progress: { (progress) in
                                                   print(progress)
                                               },
                            completionHandler: { (url) in
                                                   guard let url = url else { return }
                                                   request[MessageType.image.rawValue] = url
                                                   self.sendMessage(message: request)
                                               })
            }
        }
    }
    
    private func sendMessage(message: [String: Any]) {
        Backendless.sharedInstance().messaging.publish(channel?.channelName,
                                                       message: message,
                                                      response: { messageStatus in
                                                          print(messageStatus)
                                                      }, error: { error in
                                                          print("error")
                                                      })
    }
    
    func getUsers(successBlock: @escaping ([User]?) -> (), errorBlock: @escaping (Fault?) -> ()) {
        dataStore = Backendless.sharedInstance()!.data.ofTable(Table.users.rawValue)
        dataStore?.find({ (users) in
           successBlock(self.mapper.mapAllUsers(users: users as! [[String : Any]]))
        }, error: { (error) in
            errorBlock(error)
        })
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
