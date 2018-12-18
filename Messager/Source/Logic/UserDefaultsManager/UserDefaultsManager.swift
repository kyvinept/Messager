//
//  UserDefaultsManager.swift
//  Messager
//
//  Created by Silchenko on 18.12.2018.
//

import UIKit

class UserDefaultsManager {
    
    enum UserDefaultsKeys: String {
        case backgroundImage
    }
    
    private let userDefaults = UserDefaults()
    
    func save(backgroundImage: UIImage) {
        guard let data = UIImageJPEGRepresentation(backgroundImage, 1.0) else { return }
        userDefaults.set(data, forKey: UserDefaultsKeys.backgroundImage.rawValue)
    }
    
    func get(key: UserDefaultsKeys) -> UIImage? {
        guard let data = userDefaults.data(forKey: UserDefaultsKeys.backgroundImage.rawValue) else { return nil }
        return UIImage(data: data)
    }
}
