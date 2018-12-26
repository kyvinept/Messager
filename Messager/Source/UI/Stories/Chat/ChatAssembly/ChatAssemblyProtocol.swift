//
//  ChatAssemblyProtocol.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit

protocol ChatAssemblyProtocol {
    
    var appAssembly: ApplicationAssembly { get }
    
    func createChatViewController(currentUser: User, toUser: User, messages: [Message], giphyViewController: GiphyViewController) -> ChatViewController
    func createUsersViewController(with users: [User]) -> UsersViewController
    func createAddUserViewController() -> AddUserViewController
    func createMapViewController(withLocation location: CLLocationCoordinate2D) -> MapViewController
    func createMapViewController() -> MapViewController
    func createGiphyViewController() -> GiphyViewController
    func createCalendarViewController() -> CalendarViewController
    func createGiphyPreviewViewController(giphyUrl: String) -> GiphyPreviewViewController
    func createAttachmentsViewController(withMessages messages: [Message]) -> AttachmentsViewController
    func createFullImageViewController(withImage image: UIImage) -> FullImageViewController
    func createFullVideoViewController() -> FullVideoViewController
}
