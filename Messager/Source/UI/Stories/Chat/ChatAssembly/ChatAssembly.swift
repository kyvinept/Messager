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
    
    func createCalendarViewController() -> CalendarViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        return vc
    }
    
    func createChatViewController(currentUser: User, toUser: User, messages: [Message], giphyViewController: GiphyViewController) -> ChatViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.configure(with: currentUser, toUser: toUser, messages: messages, giphyViewController: giphyViewController)
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
    
    func createGiphyPreviewViewController(giphyUrl: String) -> GiphyPreviewViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "GiphyPreviewViewController") as! GiphyPreviewViewController
        vc.configure(url: giphyUrl)
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
    
    func createAttachmentsViewController(withMessages messages: [Message]) -> AttachmentsViewController{
        let vc = getStoryboard().instantiateViewController(withIdentifier: "AttachmentsViewController") as! AttachmentsViewController
        vc.configure(messages: messages)
        vc.title = "Attachments"
        return vc
    }
    
    func createMapViewController() -> MapViewController {
        return mapViewController()
    }
    
    func createGiphyViewController() -> GiphyViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "GiphyViewController") as! GiphyViewController
        return vc
    }
    
    func createFullImageViewController(withImage image: UIImage) -> FullImageViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "FullImageViewController") as! FullImageViewController
        vc.configure(image: image)
        vc.title = "Image"
        return vc
    }
    
    private func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Chat", bundle: nil)
    }
}
