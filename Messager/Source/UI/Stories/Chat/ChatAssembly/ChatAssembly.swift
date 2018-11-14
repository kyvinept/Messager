//
//  ChatAssembly.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit

class ChatAssembly: ChatAssemblyProtocol {
    
    var appAssembly: ApplicationAssembly
    
    init(appAssembly: ApplicationAssembly) {
        self.appAssembly = appAssembly
    }
    
    func createChatViewController(currentUser: User, toUser: User, messages: [Message]) -> ChatViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.title = "Chats"
        vc.configure(with: currentUser, toUser: toUser, messages: messages)
        return vc
    }
    
    func createUsersViewController(with users: [User]) -> UsersViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "UsersViewController") as! UsersViewController
        vc.title = "Users"
        vc.configure(users: users)
        return vc
    }
    
    func createAddUserViewController() -> AddUserViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "AddUserViewController") as! AddUserViewController
        return vc
    }
    
    private func mapViewController(withLocation location: CLLocationCoordinate2D? = nil) -> MapViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        if let location = location {
            vc.configure(location: location)
        }
        return vc
    }
    
    func createMapViewController(withLocation location: CLLocationCoordinate2D) -> MapViewController {
        return mapViewController(withLocation: location)
    }
    
    func createMapViewController() -> MapViewController {
        return mapViewController()
    }
    
    private func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Chat", bundle: nil)
    }
}
