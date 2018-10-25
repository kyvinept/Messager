//
//  ApiManager.swift
//  Messager
//
//  Created by Silchenko on 25.10.2018.
//

import UIKit
import MessageKit

class ApiManager {
    
    private var dataStore: IDataStore?
    private let tableName = "Message"
    
    init() {
        dataStore = Backendless.sharedInstance().data.ofTable(tableName)
    }
    
    func saveMessage(fromUser: User, toUser: User, message: Message) {
        var textMessage = ""
        switch message.kind {
        case .text(let text):
            textMessage = text
        default:
            break
        }
        let dataSave = ["Message" : textMessage, "ownerId": fromUser.id, "toUser": toUser.id]
        
        dataStore?.save(dataSave, response: { savedMessage in
            print("success")
        }, error: { fault in
            print("error")
        })
    }
}
