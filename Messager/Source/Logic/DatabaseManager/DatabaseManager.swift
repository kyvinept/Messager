//
//  DatabaseManager.swift
//  Messager
//
//  Created by Silchenko on 31.10.2018.
//

import UIKit
import CoreData

class DatabaseManager {
    
    private enum Entity: String {
        
        case message = "Message"
        case user = "User"
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
        queue.async {
            let entity = NSEntityDescription.entity(forEntityName: Entity.user.rawValue, in: self.persistentContainer.viewContext)
            let newUser = NSManagedObject(entity: entity!, insertInto: self.persistentContainer.viewContext) as! UserEntity
            self.databaseMapper.map(userEntity: newUser, from: user)
            self.saveContext()
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
    
    func save(message: Message, to user: User) {
        getUserEntity(successBlock: { users in
                                        var currentUser = users?.first { $0.email == user.email &&
                                                                         $0.id == user.id &&
                                                                         $0.name == user.name
                                                                        }
                                        if currentUser == nil {
                                            self.save(user: user, successBlock: { userEntity in
                                                currentUser = userEntity
                                            })
                                        }
                                        self.createMessageEntity(from: message, successBlock: { messageEntity in
                                            messageEntity.sender = currentUser!
                                        })
                                    },
                        errorBlock: { error in
                                        print(error)
                                    })
    }
    
    func getMessages(from user: User, successBlock: @escaping ([Message]?) -> (), errorBlock: @escaping (Error) -> ()) {
        queue.async {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.message.rawValue)
            fetchRequest.returnsObjectsAsFaults = false
            let context = self.persistentContainer.viewContext
            var messages = [MessageEntity]()
            
            do {
                messages = try context.fetch(fetchRequest) as! [MessageEntity]
                successBlock(self.databaseMapper.map(messagesEntity: messages))
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
