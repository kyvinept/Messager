//
//  NotificationManager.swift
//  Messager
//
//  Created by Silchenko on 04.12.2018.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
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
        Backendless.sharedInstance().messaging
        .registerDevice(deviceToken,
                        channels: ["default"],
                        response: { result in
                                      print("Success register device")
                                  },
                          error: { fault in
                                      print("Error register device")
                                 })
    }
    
    func errorRegisterDevice() {
        print("Error register device")
    }
    
    func publishMessage(message: String) {
        let publishOptions = PublishOptions()
        publishOptions.assignHeaders(["ios-alert":"alert", "ios-badge":1, "ios-sound":"default"])
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
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Open from push notification")
    }
}
