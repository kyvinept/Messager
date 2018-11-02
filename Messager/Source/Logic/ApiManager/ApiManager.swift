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
    private let timeIntervalForRequest = 5.0
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
            let message = self.mapper.map(message: dictionary)
            self.getMessageKind(text: dictionary[MessageType.text.rawValue] as! String?,
                               image: dictionary[MessageType.image.rawValue] as! String?,
                        successBlock: { messageKind in
                                           if let messageKind = messageKind {
                                               message.kind = messageKind
                                               successBlock(message)
                                           }
                                      })
        }, error: { error in
            print("error")
        })
    }
    
    func publishMessage(_ message: Message, toUser: User) {
        var request: [String: Any] = self.mapper.createRequest(message: message, toUser: toUser)
        
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
                                                                    print("downloaded to real time chat")
                                                                    self.saveMessage(message: message)
                                                                },
                                                         error: { error in
                                                                    print("error")
                                                                })
    }
    
    func getUsers(successBlock: @escaping ([User]?) -> (), errorBlock: @escaping (Fault?) -> ()) {
        dataStore = Backendless.sharedInstance()!.data.ofTable(Table.users.rawValue)
        
        let timer = Timer.scheduledTimer(withTimeInterval: timeIntervalForRequest, repeats: false) { timer in
            errorBlock(nil)
        }
        
        dataStore?.find({ (users) in
            timer.invalidate()
            successBlock(self.mapper.mapAllUsers(users: users as! [[String : Any]]))
        }, error: { (error) in
            timer.invalidate()
            errorBlock(error)
        })
    }
    
    func saveMessage(message: [String: Any]) {
        dataStore = Backendless.sharedInstance().data.ofTable(Table.message.rawValue)
        self.dataStore?.save(message, response: { savedMessage in
                                                    print("success")
                                                },
                                         error: { fault in
                                                    print("error")
                                                })
    }
    
    func getMessages(currentUser: User, successBlock: @escaping ([Message]) -> ()) {
        dataStore = Backendless.sharedInstance().data.ofTable(Table.message.rawValue)
        let queryBuilder = DataQueryBuilder()
        queryBuilder?.setWhereClause("toUserId = '" + currentUser.id + "'")
        
        dataStore?.find(queryBuilder, response: { databaseMessage in
            if let message = databaseMessage as? [[String: Any]] {
                let databaseMessage = self.mapper.mapAllMessages(messages: message)
                self.convert(datebaseMessages: databaseMessage, successBlock: { messages in

                    let group = DispatchGroup()
                    for message in messages {
                        group.enter()
                        self.databaseManager.save(message: message,
                                              currentUser: currentUser,
                                                   toUser: message.sender,
                                                    block: {
                                                              group.leave()
                                                           })
                    }
                    
                    group.notify(queue: DispatchQueue(label: "com.Messager.DatabaseManager"), execute: {
                        successBlock(messages)
                    })
                })
            }
        }, error: { error in
            print(error)
        })
    }
    
    private func convert(datebaseMessages: [DatabaseMessage], successBlock: @escaping ([Message]) -> ()) {
        getUsers(successBlock: { users in
            if let users = users {
                var messages = [Message]()
                for dbMessage in datebaseMessages {
                    var owner: User?
                    for user in users {
                        if dbMessage.ownerId == user.id {
                            owner = user
                        }
                    }
                    if owner == nil {
                        continue
                    }
                    
                    let message = Message(sender: owner!,
                                       messageId: dbMessage.messageId,
                                        sentDate: dbMessage.sentDate.toDate(),
                                            kind: MessageKind.text(""))
                    self.getMessageKind(text: dbMessage.text,
                                       image: dbMessage.image,
                                successBlock: { messageKind in
                                                   if let messageKind = messageKind {
                                                       message.kind = messageKind
                                                   }
                                              })
                    messages.append(message)
                }
                successBlock(messages)
            }
        }, errorBlock: { error in
            print(error)
        })
    }
    
    private func getMessageKind(text: String?, image: String?, successBlock: @escaping (MessageKind?) -> ()) {
        if let text = text {
            successBlock(MessageKind.text(text))
        } else if let url = image {
            self.imageManager.downloadImage(url: url,
                                       progress: { (progress) in
                                                      print(progress)
                                                 },
                              completionHandler: { messageKind in
                                                      successBlock(messageKind)
                                                 })
        }
    }
}
