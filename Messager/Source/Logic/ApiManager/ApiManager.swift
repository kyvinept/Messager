//
//  ApiManager.swift
//  Messager
//
//  Created by Silchenko on 25.10.2018.
//

import UIKit
import SwiftyJSON
import Cloudinary

class ApiManager {
    
    private enum Table: String {
        case message = "Message"
        case users = "Users"
    }
    
    private var mapper: Mapper
    private var dataStore: IDataStore?
    private let tableName = "Message"
    private var channel: Channel?
    private var lastMessage = [String]()
    private let cloudinaryUrl = "cloudinary://335865959162651:a6r9CrEp64WEkIHihFWGJccYlAA@dfneucqih"
    private var cloudinary: CLDCloudinary!
    
    init(mapper: Mapper) {
        cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudinaryUrl: cloudinaryUrl)!)
        self.mapper = mapper
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
    
    func addMessageListener(successBlock: @escaping (MessageKind?) -> (), errorBlock: @escaping (Fault?) -> ()) {
        channel?.addMessageListenerString({ message in
            guard let message = message, !self.lastMessage.contains(message) else { return }
            self.lastMessage.append(message)
            if let _ = URL(string: message) {
                self.cloudinary.createDownloader().fetchImage(message, { (progress) in
                    print(progress)
                }, completionHandler: { (image, error) in
                    if let image = image {
                        successBlock(MessageKind.photo(MediaItem(image: image, size: image.getSizeForMessage())))
                    }
                })
            } else {
                successBlock(MessageKind.text(message))
            }
        }, error: { error in
            print("error")
        })
    }
    
    func publishMessage(_ message: Message) {
        switch message.kind {
        case .text(let text):
            lastMessage.append(text)
            sendMessage(message: text)
        case .photo(let mediaItem):
            if let data = UIImageJPEGRepresentation(mediaItem.image, 0.1) {
                cloudinary.createUploader().signedUpload(data: data, params: nil, progress: { (progress) in
                    print(progress.fractionCompleted)
                }) { (result, error) in
                    if let url = result?.url {
                        self.lastMessage.append(url)
                        self.sendMessage(message: url)
                    }
                }
            }
        }
    }
    
    private func sendMessage(message: String) {
        Backendless.sharedInstance().messaging.publish(channel?.channelName, message: message, response: { messageStatus in
            print(messageStatus)
        }, error: { error in
            print("error")
        })
    }
    
    func getUsers(successBlock: @escaping ([User]?) -> (), errorBlock: @escaping (Fault?) -> ()) {
        dataStore = Backendless.sharedInstance()!.data.ofTable(Table.users.rawValue)
        dataStore?.find({ (users) in
           successBlock(self.mapper.allUsers(users: users as! [[String : Any]]))
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
