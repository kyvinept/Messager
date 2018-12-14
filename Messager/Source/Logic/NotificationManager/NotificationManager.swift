//
//  NotificationManager.swift
//  Messager
//
//  Created by Silchenko on 04.12.2018.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    var newNotificationMessage: (() -> ())?
    var currentUser: User? {
        didSet {
            guard let deviceToken = deviceToken else { return }
            register(deviceForRemoteNotification: deviceToken)
        }
    }
    
    private var currentDevice: String?
    private var databaseManager: DatabaseManager
    private var deviceToken: Data?
    
    init(databaseManager: DatabaseManager) {
        self.databaseManager = databaseManager
        super.init()
    }
    
    func startNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func register(deviceForRemoteNotification deviceToken: Data) {
        self.deviceToken = deviceToken
        createChannelNames(successBlock: { names in
                                            guard let names = names else { return }
                                            Backendless.sharedInstance().messaging.
                                            .registerDevice(deviceToken,
                                                            channels: names,
                                                            response: { [weak self] result in
                                                                           print("Success register device")
                                                                           self?.currentDevice = result
                                                                      },
                                                               error: { fault in
                                                                           print("Error register device")
                                                                      })
                                        },
                            errorBlock: {
                                            print("Error register device")
                                        })
    }
    
    func unregisterDevice() {
        guard let currentDevice = currentDevice else { return }
        Backendless.sharedInstance()?.messaging.unregisterDevice(currentDevice,
                                                                 response: {
                                                                                print("success unregister device")
                                                                           },
                                                                    error: { error in
                                                                                print("error unregister device")
                                                                           })
    }
    
    func errorRegisterDevice() {
        print("Error register device")
    }
    
    func publishMessage(message: String, channelName: String) {
        let publishOptions = PublishOptions()
        publishOptions.assignHeaders(["ios-alert": message, "ios-badge":1, "ios-sound":"default"])
        let deliveryOptions = DeliveryOptions()
        deliveryOptions.publishAt = Date(timeIntervalSinceNow: 1)
        deliveryOptions.publishPolicy(PUSH.rawValue)
        Backendless.sharedInstance().messaging.publish("default",
                                                       message: message,
                                                publishOptions: publishOptions,
                                               deliveryOptions: deliveryOptions,
                                                      response: { status in
                                                                    print("push succeed")
                                                                },
                                                         error: { fault in
                                                                    print("fail publish notification")
                                                                })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("New message")
        UIApplication.shared.applicationIconBadgeNumber = 0
        //newNotificationMessage?()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Open from push notification")
        UIApplication.shared.applicationIconBadgeNumber = 0
        newNotificationMessage?()
    }
}

private extension NotificationManager {
    
    func createChannelNames(successBlock: @escaping ([String]?) -> (), errorBlock: @escaping () -> ()) {
        guard let currentUser = currentUser else {
            errorBlock()
            return
        }
        
        databaseManager.getUsers(successBlock: { users in
            guard let users = users else { return }
            var channelNames = [String]()
            for user in users {
                var users = [currentUser.id, user.id]
                users.sort()
                users[0].removeSubrange(String.Index(encodedOffset: 22)...String.Index(encodedOffset: users[0].count-1))
                users[1].removeSubrange(String.Index(encodedOffset: 22)...String.Index(encodedOffset: users[1].count-1))
                let idChat = users[1] + users[0]
                channelNames.append(idChat)
            }
            successBlock(channelNames)
        }, errorBlock: {_ in
            errorBlock()
        })
    }
}
