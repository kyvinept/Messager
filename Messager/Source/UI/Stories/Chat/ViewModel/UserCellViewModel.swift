//
//  UserCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 29.10.2018.
//

import UIKit

struct UserCellViewModel {
    
    var userName: String
    var lastMessage: String?
    var lastMessageTime: String?
    var userImage: UIImage
    
    init(userName: String, lastMessage: String?, lastMessageTime: Date?, userImage: UIImage = UIImage(named: "person")!) {
        self.userName = userName
        self.lastMessage = lastMessage
        self.userImage = userImage
        if let date = lastMessageTime {
            self.lastMessageTime = self.convertDate(date: date)
        }
    }
    
    private func convertDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        return myString
    }
}
