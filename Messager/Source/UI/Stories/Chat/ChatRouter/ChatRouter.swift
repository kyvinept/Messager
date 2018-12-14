//
//  Chatrouter.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit

class ChatRouter: BaseRouter, ChatRouterProtocol {

    var assembly: ChatAssemblyProtocol
    private var chatViewController: ChatViewController?
    private var usersViewController: UsersViewController?
    private var addUserViewController: AddUserViewController?
    private var mapViewController: MapViewController?
    private var calendarViewController: CalendarViewController?
    private var rootViewController: UIViewController!
    lazy private var currentUser: User? = {
        return assembly.appAssembly.authorizationManager.currentUser
    }()
    
    init(assembly: ChatAssemblyProtocol) {
        self.assembly = assembly
        super.init()
        initForNotification()
        assembly.appAssembly.notificationManager.currentUser = currentUser
    }
    
    func showInitialVC(from rootViewController: UIViewController) {
        showUsersViewController(from: rootViewController)
        self.rootViewController = rootViewController
    }
    
    private func initForNotification() {
        assembly.appAssembly.notificationManager.newNotificationMessage = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.assembly.appAssembly.apiManager
            .getNewMessage(toUser: strongSelf.currentUser!,
                     successBlock: { [weak self] message in
                                       guard let strongSelf = self else { return }
                                       if strongSelf.chatViewController != nil {
                                           strongSelf.checkNewMessages(currentUser: strongSelf.currentUser!,
                                                                            toUser: message.sender)
                                           return
                                       }
                                       DispatchQueue.main.async {
                                           strongSelf.showChatViewController(from: strongSelf.rootViewController,
                                                                      currentUser: strongSelf.currentUser!,
                                                                           toUser: message.sender)
                                       }
                                   },
                       errorBlock: {
                                       print("Error load new message")
                                   })
        }
    }
    
    private func showChatViewController(from viewController: UIViewController, currentUser: User, toUser: User) {
        let giphy = self.assembly.createGiphyViewController()
        giphy.delegate = self
        let vc = self.assembly.createChatViewController(currentUser: currentUser,
                                                             toUser: toUser,
                                                           messages: toUser.messages,
                                                giphyViewController: giphy)
        vc.delegate = self
        self.realtimeChat(currentUser: currentUser,
                               toUser: toUser,
                       viewController: vc)
        self.chatViewController = vc
        DispatchQueue.main.async {
            self.action(with: vc,
                        from: viewController,
                        with: .push,
                    animated: true)
            viewController.tabBarController?.tabBar.isHidden = true
        }
        self.checkNewMessages(currentUser: currentUser, toUser: toUser)
    }
    
    private func checkNewMessages(currentUser: User, toUser: User) {
        self.assembly.appAssembly.apiManager.getMessages(currentUser: currentUser, toUser: toUser) { message in
            self.chatViewController?.showNewMessage(message)
        }
    }
    
    private func realtimeChat(currentUser: User, toUser: User, viewController: UIViewController) {
        let refresh = showProgress(toViewController: viewController)
        assembly.appAssembly.apiManager
            .startRealtimeChat(fromUser: currentUser,
                                 toUser: toUser,
                           successBlock: {
                                             refresh.dismiss()
                                             self.assembly.appAssembly.apiManager
                                             .addMessageListener(successBlock: { message in
                                                 if let message = message {
                                                     self.assembly.appAssembly.databaseManager
                                                        .save(message: message,
                                                          currentUser: currentUser,
                                                               toUser: toUser,
                                                                block: {
                                                                            if message.sender != currentUser {
                                                                                self.chatViewController?.showNewMessage(message)
                                                                            } else {
                                                                                self.chatViewController?.update(message: message)
                                                                            }
                                                                       })
                                                 }
                                             }, errorBlock: { error in
                                                 print("error")
                                             })
                                         },
                             errorBlock: {
                                             refresh.dismiss()
                                             //self.showInfo(to: viewController, title: "Error", message: error?.detail ?? "")
                                         })
    }
}

extension ChatRouter {
    
    private func showUsersViewController(from rootViewController: UIViewController) {
        assembly.appAssembly.databaseManager.getUsers(successBlock: { users in
            self.getMessages(forUsers: users)
            let vc = self.assembly.createUsersViewController(with: users ?? [User]())
            vc.delegate = self
            self.usersViewController = vc
            DispatchQueue.main.async {
                self.action(with: vc,
                            from: rootViewController,
                            with: .push,
                        animated: true)
            }
            self.checkNewUsers()
        }) { error in
            print(error)
        }
    }
    
    private func getMessages(forUsers users: [User]?) {
        guard let users = users else { return }
        for user in users {
            assembly.appAssembly.databaseManager.getMessages(currentUser: currentUser!,
                                                                  toUser: user,
                                                            successBlock: { messages in
                                                                              user.messages = messages ?? [Message]()
                                                                              self.checkNewMessagesForUser(currentUser: self.currentUser!, toUser: user)
                                                                          },
                                                              errorBlock: { error in
                                                                              print("Error get local messages")
                                                                          })
        }
    }
    
    private func checkNewMessagesForUser(currentUser: User, toUser: User) {
        self.assembly.appAssembly.apiManager.getMessages(currentUser: currentUser, toUser: toUser) { message in
            if !toUser.messages.contains(where: { $0 == message } ) {
                toUser.messages.append(message)
                self.usersViewController?.refreshData()
            }
        }
    }
    
    private func checkNewUsers() {
        assembly.appAssembly.apiManager.getNewUsers(currentUser: currentUser!,
                                                   successBlock: { users in
                                                                     self.usersViewController?.downloaded(users: users)
                                                                     self.getMessages(forUsers: users)
                                                                 },
                                                     errorBlock: { error in
                                                                     self.showInfo(to: self.usersViewController!,
                                                                                title: "Error",
                                                                              message: error ?? "Unknowed error")
                                                                     self.usersViewController?.cancelRefresh()
                                                                 })
    }
}

extension ChatRouter: UsersViewControllerDelegate {
    
    func didRefreshUsers(from viewController: UsersViewController) {
        assembly.appAssembly.apiManager.getNewUsers(currentUser: currentUser!,
                                                   successBlock: { users in
                                                                     self.usersViewController?.downloaded(users: users)
                                                                 },
                                                     errorBlock: { error in
                                                                     self.showInfo(to: self.usersViewController!,
                                                                                title: "Error",
                                                                              message: error ?? "Unknowed error")
                                                                     self.usersViewController?.cancelRefresh()
                                                                 })
    }
    
    func didTouchAddUserButton(from viewController: UsersViewController) {
        let vc = assembly.createAddUserViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.addUserViewController = vc
        DispatchQueue.main.async {
            self.action(with: vc,
                        from: viewController,
                        with: .present,
                    animated: true)
        }
        viewController.tabBarController?.tabBar.isUserInteractionEnabled = false
    }

    
    func didSelectCell(with user: User, from viewController: UsersViewController) {
        showChatViewController(from: viewController, currentUser: currentUser!, toUser: user)
    }
}

extension ChatRouter: AddUserViewControllerDelegate {
    
    func addUserViewController(with email: String, viewController: AddUserViewController, didTouchInputButton sender: UIButton) {
        sender.isEnabled = false
        assembly.appAssembly.apiManager.getUsers(successBlock: { users in
            let user = users?.first { $0.email == email }
            
            if let user = user, user != self.currentUser! {
                
                self.assembly.appAssembly.databaseManager.save(user: user)
                self.assembly.appAssembly.databaseManager.getUsers(successBlock: { users in
                    self.usersViewController?.configure(users: users ?? [User]())
                }, errorBlock: { error in
                    print("Error")
                })
                self.usersViewController?.tabBarController?.tabBar.isUserInteractionEnabled = true
                viewController.dismiss(animated: true, completion: nil)
                
            } else if user == self.currentUser! {
                
                sender.isEnabled = true
                self.addUserViewController?.showError(text: "You can't add yourself.")
                
            } else {
                
                sender.isEnabled = true
                self.addUserViewController?.showError(text: "No user with this email.")
            }
        }, errorBlock: { (error) in
            print("error")
        })
    }
    
    func addUserViewController(viewController: AddUserViewController, didTouchCancelButton sender: UIButton) {
        usersViewController?.tabBarController?.tabBar.isUserInteractionEnabled = true
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension ChatRouter: ChatViewControllerDelegate {
   
    func didTappedCalendarButton(viewController: ChatViewController) {
        let vc = assembly.createCalendarViewController()
        self.calendarViewController = vc
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.action(with: vc,
                    from: viewController.navigationController!,
                    with: .present,
                animated: false)
    }
    
    func didEditTextMessage(message: Message, toUser: User, viewController: ChatViewController) {
        let progress = showProgress(toViewController: viewController)
        assembly.appAssembly.apiManager.edit(message: message,
                                              toUser: toUser,
                                        successBlock: {
                                                          progress.dismiss()
                                                      },
                                          errorBlock: {
                                                          progress.dismiss()
                                                      })
    }
    
    func didTappedRemoveMessageButton(message: Message, toUser: User, viewController: ChatViewController) {
        let progress = showProgress(toViewController: viewController)
        assembly.appAssembly.apiManager.remove(message: message,
                                                toUser: toUser,
                                          successBlock: {
                                                            print("Success delete")
                                                            progress.dismiss()
                                                        },
                                            errorBlock: {
                                                            progress.dismiss()
                                                        })
    }
   
    func didTappedSearchGiphyButton(search: String, pageNumber: Int, viewController: ChatViewController, successBlock: @escaping ([Giphy]) -> ()) {
        assembly.appAssembly.giphyManager.getGiphy(withQuery: search,
                                                  pageNumber: pageNumber,
                                                successBlock: { giphy in
                                                                  successBlock(giphy)
                                                              },
                                                  errorBlock: { error in
                                                                  print("error")
                                                              })
    }
    
    func didTouchChoseLocation(viewController: ChatViewController) {
        let vc = assembly.createMapViewController()
        vc.delegate = self
        self.mapViewController = vc
        action(with: vc,
               from: viewController.navigationController!,
               with: .push,
           animated: true)
    }
    
    func didTappedLocationCell(withLocation location: CLLocationCoordinate2D, viewController: ChatViewController) {
        let vc = assembly.createMapViewController(withLocation: location)
        self.mapViewController = vc
        action(with: vc,
               from: viewController.navigationController!,
               with: .push,
           animated: true)
    }
    
    func didTouchGetCurrentLocation(viewController: ChatViewController) {
        assembly.appAssembly.locationManager
        .getCurrentLocation(successBlock: { coordinate in
                                              viewController.newMessage(withLocation: coordinate)
                                          },
                              errorBlock: {
                                              print("error")
                                          })
    }
    
    func didTouchSendMessageButton(with message: Message, toUser: User, viewController: ChatViewController) {
        assembly.appAssembly.apiManager.publishMessage(message,
                                                       toUser: toUser,
                                                 successBlock: {
                                                                   print("Success publish")
                                                               },
                                                   errorBlock: {
                                                                    print("Error publish")
                                                               })
    }
    
    func didTouchBackButton(viewController: ChatViewController) {
        viewController.navigationController?.popViewController(animated: true)
        viewController.tabBarController?.tabBar.isHidden = false
        chatViewController = nil
    }
}

extension ChatRouter: MapViewControllerDelegate {
   
    func didChoseCustomLocation(withLocation location: CLLocationCoordinate2D, viewController: MapViewController) {
        viewController.navigationController?.popViewController(animated: true)
        chatViewController?.newMessage(withLocation: location)
    }
    
    func didGetCurrentLocationButtonTapped(viewController: MapViewController) {
        assembly.appAssembly.locationManager.getCurrentLocation(successBlock: { location in
                                                                                  viewController.set(myLocation: location)
                                                                              },
                                                                  errorBlock: {
                                                                                  print("error get location")
                                                                              })
    }
}

extension ChatRouter: GiphyViewControllerDelegate {
    
    func didShowActivityIndicator(viewController: GiphyViewController, successBlock: @escaping ([Giphy]) -> (), errorBlock: @escaping (Error?) -> ()) {
        assembly.appAssembly.giphyManager.getNewItemFromLastRequest(successBlock: { giphy in
                                                                                      successBlock(giphy)
                                                                                  },
                                                                      errorBlock: { error in
                                                                                      errorBlock(error)
                                                                                  })
    }
    
    func didTappedGetTrendingGiphy(pageNumber: Int, successBlock: @escaping ([Giphy]) -> (), viewController: GiphyViewController) {
        assembly.appAssembly.giphyManager.getTrendingGiphy(pageNumber: pageNumber,
                                                         successBlock: { giphy in
                                                                            successBlock(giphy)
                                                                       },
                                                           errorBlock: { error in
                                                                            print("error")
                                                                       })
    }
}

extension ChatRouter: CalendarViewControllerDelegate {
    
    func didChoseDate(_ date: Date, viewController: CalendarViewController) {
        viewController.dismiss(animated: false, completion: nil)
        calendarViewController = nil
        chatViewController?.searchMessages(byDate: date)
    }
    
    func didTappedCancelButton(viewController: CalendarViewController) {
        viewController.dismiss(animated: false, completion: nil)
        calendarViewController = nil
    }
}
