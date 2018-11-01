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
    
    func save(user: User) {
        save(user: user) { _ in
            print("Save user!")
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
    
    private func save(user: User, successBlock: @escaping (UserEntity) -> ()) {
        getUsers(successBlock: { users in
            var isInclude = false
            if let users = users, users.contains(user) {
                isInclude = true
            }
            if !isInclude {
                let entity = NSEntityDescription.entity(forEntityName: Entity.user.rawValue, in: self.persistentContainer.viewContext)
                let newUser = NSManagedObject(entity: entity!, insertInto: self.persistentContainer.viewContext) as! UserEntity
                self.databaseMapper.map(userEntity: newUser, from: user)
                self.saveContext()
            }
        }) { (error) in
            print("error")
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
    
    func save(message: Message, currentUser: User, toUser: User, successBlock: @escaping () -> ()) {
        getUserEntity(successBlock: { users in
                                        var checkUser = users?.first { $0.email == toUser.email &&
                                                                         $0.id == toUser.id &&
                                                                         $0.name == toUser.name
                                                                        }
                                        if checkUser == nil {
                                            self.save(user: toUser, successBlock: { userEntity in
                                                checkUser = userEntity
                                            })
                                        }
                                        self.checkMessage(currentUser: currentUser,
                                                               toUser: toUser,
                                                            checkUser: checkUser!,
                                                              message: message,
                                                         successBlock: {
                                                                           successBlock()
                                                                       })
                                    },
                        errorBlock: { error in
                                        print(error)
                                    })
    }
    
    private func checkMessage(currentUser: User, toUser: User, checkUser: UserEntity, message: Message, successBlock: @escaping () -> ()) {
        self.getMessages(currentUser: currentUser,
                         toUser: toUser,
                         successBlock: { messages in
                                            if let messages = messages, messages.contains (where: { $0.sender == message.sender &&
                                                                                                    $0.sentDate == message.sentDate &&
                                                                                                    $0.messageId == message.messageId }) {
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
                            
                                       })
    }
    
    func getMessages(currentUser: User, toUser: User, successBlock: @escaping ([Message]?) -> (), errorBlock: @escaping (Error) -> ()) {
        queue.async {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.message.rawValue)
            fetchRequest.returnsObjectsAsFaults = false
            let context = self.persistentContainer.viewContext
            var messages = [MessageEntity]()
            
            do {
                messages = try context.fetch(fetchRequest) as! [MessageEntity]
                successBlock(self.databaseMapper.map(messagesEntity: messages,
                                                        currentUser: currentUser,
                                                             toUser: toUser))
            } catch {
                errorBlock(error)
            }
        }
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
