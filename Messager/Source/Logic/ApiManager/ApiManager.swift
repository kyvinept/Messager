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
    private var mediaManager: MediaManager
    private let timeIntervalForRequest = 5.0
    private var databaseManager: DatabaseManager
    
    init(mapper: Mapper, mediaManager: MediaManager, databaseManager: DatabaseManager) {
        self.mapper = mapper
        self.mediaManager = mediaManager
        self.databaseManager = databaseManager
    }
    
    func updateImage(image: UIImage, user: User, successBlock: @escaping (String) -> ()) {
        if let data = UIImageJPEGRepresentation(image, 0.1) {
            mediaManager.uploadImage(data: data,
                                 progress: { progress in
                                               print(progress)
                                           },
                        completionHandler: { url in
                                               if let url = url {
                                                   self.updateUserField(name: nil,
                                                                       email: nil,
                                                                    password: nil,
                                                                    imageUrl: url,
                                                                      userId: user.id,
                                                                successBlock: { _ in
                                                                                  successBlock(url)
                                                                              })
                                               }
                                           })
        }
    }
    
    func updateField(name: String?, email: String?, password: String?, user: User, successBlock: @escaping (User) -> ()) {
        self.updateUserField(name: name,
                            email: email,
                         password: password,
                         imageUrl: nil,
                           userId: user.id,
                     successBlock: { backendlessUser in
                                       successBlock(self.mapper.mapUser(fromBackendlessUser: backendlessUser))
                                   })
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
                            location: dictionary[MessageType.location.rawValue] as! String?,
                               video: dictionary[MessageType.video.rawValue] as! String?,
                               giphy: dictionary[MessageType.giphy.rawValue] as! String?,
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
                mediaManager.uploadImage(data: data,
                                     progress: { (progress) in
                                                   print(progress)
                                               },
                            completionHandler: { (url) in
                                                   guard let url = url else { return }
                                                   request[MessageType.image.rawValue] = url
                                                   self.sendMessage(message: request)
                                               })
            }
        case .location(let location):
            request[MessageType.location.rawValue] = "\(location.latitude),\(location.longitude)"
            sendMessage(message: request)
        case .video(let videoItem):
            mediaManager.uploadVideo(url: videoItem.videoUrl,
                               chunkSize: videoItem.bytes,
                                progress: { progress in
                                               print(progress)
                                          },
                       completionHandler: { url in
                                               guard let url = url else { return }
                                               request[MessageType.video.rawValue] = url
                                               self.sendMessage(message: request)
                                          })
        case .giphy(let giphy):
            request[MessageType.giphy.rawValue] = giphy.url
            sendMessage(message: request)
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
    
    func getUsers(successBlock: @escaping ([User]?) -> (), errorBlock: @escaping (Fault?) -> (), currentUserId: String = "") {
        dataStore = Backendless.sharedInstance()!.data.ofTable(Table.users.rawValue)
        let queryBuilder = DataQueryBuilder()
        if !currentUserId.isEmpty {
            queryBuilder?.setWhereClause("ownerId = '" + currentUserId + "'")
        }
        
        dataStore?.find(queryBuilder,
                        response: { (users) in
                                      successBlock(self.mapper.mapAllUsers(users: users as! [[String : Any]]))
                                  },
                           error: { (error) in
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
    
    func getNewUsers(currentUser: User, successBlock: @escaping ([User]) -> (), errorBlock: @escaping (String?) -> ()) {
        let timer = Timer(timeInterval: timeIntervalForRequest, repeats: false) { timer in
            errorBlock("Check your internet connection")
        }
        
        dataStore = Backendless.sharedInstance().data.ofTable(Table.message.rawValue)
        let queryBuilder = DataQueryBuilder()
        queryBuilder?.setWhereClause("ownerId = '" + currentUser.id + "' || toUserId = '" + currentUser.id + "'")
        
        dataStore?.find(queryBuilder, response: { databaseMessage in
            if let message = databaseMessage as? [[String: Any]] {
                let databaseMessage = self.mapper.mapAllMessages(messages: message)
                
                self.dataStore = Backendless.sharedInstance().data.ofTable(Table.users.rawValue)
                let queryBuilder = DataQueryBuilder()
                
                guard let whereClause = self.getStringToSearchUser(currentUser: currentUser, messages: databaseMessage) else {
                    timer.invalidate()
                    errorBlock(nil)
                    return
                }
                queryBuilder?.setWhereClause(whereClause)
                
                self.dataStore?.find(queryBuilder, response: { databaseUser in
                    let users = self.mapper.mapAllUsers(users: databaseUser as! [[String : Any]])
                    self.databaseManager.save(users: users)
                    timer.invalidate()
                    successBlock(users)
                }, error: { error in
                    timer.invalidate()
                    errorBlock(error?.detail)
                })
            }
        }, error: { error in
            timer.invalidate()
            errorBlock(error?.detail)
        })
    }
    
    private func getStringToSearchUser(currentUser: User, messages: [DatabaseMessage]) -> String? {
        var idUsers = [String]()
        for message in messages {
            if currentUser.id == message.ownerId {
                if !idUsers.contains(message.toUserId) {
                    idUsers.append(message.toUserId)
                }
            } else {
                if !idUsers.contains(message.ownerId) {
                    idUsers.append(message.ownerId)
                }
            }
        }
        
        var whereClause = ""
        for id in idUsers {
            whereClause += "|| ownerId = '" + id + "' "
        }
        return whereClause.isEmpty ? nil : String(whereClause[String.Index.init(encodedOffset: 3)...])
    }
    
    func getMessages(currentUser: User, toUser: User, successBlock: @escaping (Message) -> ()) {
        dataStore = Backendless.sharedInstance().data.ofTable(Table.message.rawValue)
        let queryBuilder = DataQueryBuilder()
        queryBuilder?.setWhereClause("(ownerId = '" + currentUser.id + "' && toUserId = '" + toUser.id + "') || (toUserId = '" + currentUser.id + "' && ownerId = '" + toUser.id + "')")
        
        dataStore?.find(queryBuilder, response: { databaseMessage in
            if let message = databaseMessage as? [[String: Any]] {
                let databaseMessage = self.mapper.mapAllMessages(messages: message)
                self.convert(from: databaseMessage,
                             with: currentUser,
                           toUser: toUser,
                     successBlock: { message in
                                        successBlock(message)
                                   },
                                   errorBlock: {
                                        print("error")
                                   })
            }
        }, error: { error in
            print(error)
        })
    }
    
    private func convert(from dbMessages: [DatabaseMessage], with currentUser: User, toUser: User, successBlock: @escaping (Message) -> (), errorBlock: @escaping () -> ()) {
        for dbMessage in dbMessages {
            getMessageKind(text: dbMessage.text, image: dbMessage.image, location: dbMessage.location, video: dbMessage.video, giphy: dbMessage.giphy) { messageKind in
                guard let messageKind = messageKind else {
                    errorBlock()
                    return
                }
                let message = Message(sender: dbMessage.ownerId == currentUser.id ? currentUser : toUser,
                                   messageId: dbMessage.messageId,
                                    sentDate: dbMessage.sentDate.toDate()!,
                                        kind: messageKind)
                self.databaseManager.save(message: message,
                                      currentUser: currentUser,
                                           toUser: toUser,
                                            block: {
                                                       successBlock(message)
                                                   })
            }
        }
    }
    
    private func getMessageKind(text: String?, image: String?, location: String?, video: String?, giphy: String?, successBlock: @escaping (MessageKind?) -> ()) {
        if let text = text {
            successBlock(MessageKind.text(text))
        } else if let url = image {
            self.mediaManager.downloadImage(url: url,
                                       progress: { (progress) in
                                                      print(progress)
                                                 },
                              completionHandler: { messageKind in
                                                      successBlock(messageKind)
                                                 })
        } else if let location = location {
            let locationSplit = location.split(separator: ",")
            guard let latitude = Double(locationSplit[0]),
                  let longitude = Double(locationSplit[1]) else { return }
            successBlock(MessageKind.location(CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
        } else if let video = video {
            successBlock(MessageKind.video(VideoItem(videoUrl: URL(string: video)!, downloaded: true)))
        } else if let giphy = giphy {
            successBlock(MessageKind.giphy(Giphy(id: String(giphy.split(separator: "/")[4]), url: giphy)))
        }
    }
}

private extension ApiManager {
    
    func updateUserField(name: String?, email: String?, password: String?, imageUrl: String?, userId: String, successBlock: @escaping (BackendlessUser) -> ()) {
        dataStore = Backendless.sharedInstance().data.ofTable(Table.users.rawValue)
        let queryBuilder = DataQueryBuilder()
        queryBuilder?.setWhereClause("ownerId = '" + userId + "'")
        
        dataStore?.find(queryBuilder, response: { findUser in
            if let currentUser = findUser as? [[String: Any]] {
                let backendlessUser = BackendlessUser(properties: currentUser[0])
                
                if let name = name {
                    backendlessUser?.updateProperties(["name" : name])
                }
                if let email = email {
                    backendlessUser?.updateProperties(["email" : email])
                }
                if let password = password {
                    backendlessUser?.updateProperties(["password" : password])
                }
                if let imageUrl = imageUrl {
                    backendlessUser?.updateProperties(["image" : imageUrl])
                }
                Backendless.sharedInstance()?.userService.update(backendlessUser,
                                                                 response: { updateUser in
                                                                                if let updateUser = updateUser {
                                                                                    successBlock(updateUser)
                                                                                }
                                                                           },
                                                                    error: { error in
                                                                                print("Error update image in database")
                                                                           })
            }
        }, error: { error in
            print(error)
        })
    }
}
