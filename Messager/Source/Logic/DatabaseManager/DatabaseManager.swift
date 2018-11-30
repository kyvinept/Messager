//
//  DatabaseManager.swift
//  Messager
//
//  Created by Silchenko on 31.10.2018.
//

import UIKit
import CoreData

enum MessageDirection: String {
    case from
    case to
}

class DatabaseManager {
    
    private enum Entity: String {
        
        case message = "MessageEntity"
        case user = "UserEntity"
    }
    
    private let databaseName = "Messager"
    private let queue = DispatchQueue(label: "com.Messager.DatabaseManager")
    private var databaseMapper: DatabaseMapper
    private let waitTimeInterval = 5
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: databaseName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func saveContext () {
        queue.async {
            let context = self.persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("error save data")
                }
            }
        }
    }
    
    init(databaseMapper: DatabaseMapper) {
        self.databaseMapper = databaseMapper
    }
}

extension DatabaseManager {
    
    func save(users: [User]) {
        for user in users {
            self.save(user: user)
        }
    }
    
    func save(user: User) {
        save(user: user, successBlock: { userEntity in
            print("Success")
        }) {
            print("Error")
        }
    }
    
    func getUsers(successBlock: @escaping ([User]?) -> (), errorBlock: @escaping (Error) -> ()) {
        getUserEntity(successBlock: { usersEntity in
                                        if let usersEntity = usersEntity {
                                            successBlock(self.databaseMapper.map(users: usersEntity))
                                        }
                                     },
                                     errorBlock: { error in
                                        errorBlock(error)
                                     })
    }
    
    func removeAddUsers() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.user.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        let context = self.persistentContainer.viewContext
        var users = [UserEntity]()
        
        do {
            users = try context.fetch(fetchRequest) as! [UserEntity]
            for user in users {
                persistentContainer.viewContext.delete(user)
            }
            saveContext()
        } catch {
            print(error)
        }
    }
    
    private func save(user: User, successBlock: @escaping (UserEntity) -> (), errorBlock: @escaping () -> ()) {
        getUsers(successBlock: { users in
            if let users = users, users.contains(user) {
                errorBlock()
                return
            }
            let entity = NSEntityDescription.entity(forEntityName: Entity.user.rawValue, in: self.persistentContainer.viewContext)
            let newUser = NSManagedObject(entity: entity!, insertInto: self.persistentContainer.viewContext) as! UserEntity
            self.databaseMapper.map(userEntity: newUser, from: user)
            self.saveContext()
            successBlock(newUser)
        }) { (error) in
            print("error")
            errorBlock()
        }
    }
    
    private func getUserEntity(successBlock: @escaping ([UserEntity]?) -> (), errorBlock: @escaping (Error) -> ()) {
        queue.async {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.user.rawValue)
            fetchRequest.returnsObjectsAsFaults = false
            let context = self.persistentContainer.viewContext
            var users = [UserEntity]()
            
            do {
                users = try context.fetch(fetchRequest) as! [UserEntity]
                successBlock(users)
            } catch {
                errorBlock(error)
            }
        }
    }
}

extension DatabaseManager {
    
    func save(message: Message, currentUser: User, toUser: User, block: @escaping () -> ()) {
        getUserEntity(successBlock: { users in
                                        var checkUser = users?.first { $0.email == toUser.email &&
                                                                       $0.id == toUser.id &&
                                                                       $0.name == toUser.name
                                                                     }
                                        if checkUser == nil {
                                            self.save(user: toUser, successBlock: { userEntity in
                                                checkUser = userEntity
                                                self.checkMessage(currentUser: currentUser,
                                                                       toUser: toUser,
                                                                    checkUser: checkUser!,
                                                                      message: message,
                                                                 successBlock: {
                                                                                   block()
                                                                               },
                                                                   errorBlock: {
                                                                                   block()
                                                                               })
                                            },
                                            errorBlock: {
                                                block()
                                            })
                                        } else {
                                            self.checkMessage(currentUser: currentUser,
                                                                   toUser: toUser,
                                                                checkUser: checkUser!,
                                                                  message: message,
                                                             successBlock: {
                                                                               block()
                                                                           },
                                                               errorBlock: {
                                                                               block()
                                                                           })
                                        }
                                    },
                        errorBlock: { error in
                                        print(error)
                                        block()
                                    })
    }
    
    func remove(message: Message, toUser: User, successBlock: @escaping () -> (), errorBlock: @escaping () -> ()) {
        queue.async {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.user.rawValue)
            fetchRequest.returnsObjectsAsFaults = false
            let context = self.persistentContainer.viewContext
            
            do {
                let users = try context.fetch(fetchRequest) as? [UserEntity]
                if let user = users?.first(where: { $0.email == toUser.email &&
                                                    $0.id == toUser.id &&
                                                    $0.name == toUser.name }) {
                    let messages = user.messages?.allObjects as! [MessageEntity]
                    if let deleteMessage = messages.first (where: { $0.sentDate == message.sentDate && $0.messageId == message.messageId }) {
                        context.delete(deleteMessage)
                        self.saveContext()
                        print("Success delete from local db")
                    }
                }
            } catch {
                print("error")
            }
        }
    }
    
    func edit(message: Message, toUser: User, successBlock: @escaping () -> (), errorBlock: @escaping () -> ()) {
        queue.async {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.user.rawValue)
            fetchRequest.returnsObjectsAsFaults = false
            let context = self.persistentContainer.viewContext
            
            do {
                let users = try context.fetch(fetchRequest) as? [UserEntity]
                if let user = users?.first(where: { $0.email == toUser.email &&
                    $0.id == toUser.id &&
                    $0.name == toUser.name }) {
                    let messages = user.messages?.allObjects as! [MessageEntity]
                    if let editMessage = messages.first (where: { $0.sentDate == message.sentDate && $0.messageId == message.messageId }) {
                        switch message.kind {
                        case .text(let text):
                            editMessage.text = text
                        default:
                            break
                        }
                    }
                }
                self.saveContext()
            } catch {
                print("error")
            }
        }
    }
    
    func getMessages(currentUser: User, toUser: User, successBlock: @escaping ([Message]?) -> (), errorBlock: @escaping (Error) -> ()) {
        getUserEntity(successBlock: { users in
            if let user = users?.first(where: { $0.email == toUser.email &&
                                                $0.id == toUser.id &&
                                                $0.name == toUser.name }) {
                let messages = user.messages?.allObjects as! [MessageEntity]
                successBlock(self.databaseMapper.map(messagesEntity: messages,
                                                        currentUser: currentUser,
                                                             toUser: toUser))
            }
        }) { error in
            print(error)
        }
    }
    
    private func checkMessage(currentUser: User, toUser: User, checkUser: UserEntity, message: Message, successBlock: @escaping () -> (), errorBlock: @escaping () -> ()) {
        self.getMessages(currentUser: currentUser,
                         toUser: toUser,
                         successBlock: { messages in
                                            if let messages = messages, messages.contains (where: { $0.sender == message.sender &&
                                                                                                    $0.sentDate == message.sentDate &&
                                                                                                    $0.messageId == message.messageId }) {
                                                errorBlock()
                                                return
                                            }
                                            self.createMessageEntity(from: message, successBlock: { messageEntity in
                                                messageEntity.user = checkUser
                                                if message.sender == toUser {
                                                    messageEntity.direction = MessageDirection.from.rawValue
                                                } else {
                                                    messageEntity.direction = MessageDirection.to.rawValue
                                                }
                                                successBlock()
                                            })
                                       },
                           errorBlock: { error in
                                           errorBlock()
                                       })
    }
    
    private func createMessageEntity(from message: Message, successBlock: @escaping (MessageEntity) -> ()) {
        queue.async {
            let entity = NSEntityDescription.entity(forEntityName: Entity.message.rawValue, in: self.persistentContainer.viewContext)
            let newMessage = NSManagedObject(entity: entity!, insertInto: self.persistentContainer.viewContext) as! MessageEntity
            self.databaseMapper.map(to: newMessage, from: message)
            successBlock(newMessage)
            self.saveContext()
        }
    }
}
