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
    
    private enum BackgroundImage: String {
        case id = "backgroundImageId"
    }
    
    private let userDefaults = UserDefaults()
    
    func save(backgroundImage: Image) {
        DispatchQueue(label: "com.userDefaults", attributes: .concurrent).async { [weak self] in
            guard let image = backgroundImage.image, let data = UIImageJPEGRepresentation(image, 1.0) else { return }
            self?.userDefaults.set(data, forKey: UserDefaultsKeys.backgroundImage.rawValue)
            self?.userDefaults.set(backgroundImage.id, forKey: BackgroundImage.id.rawValue)
        }
    }
    
    func get(key: UserDefaultsKeys) -> Image? {
        guard let data = userDefaults.data(forKey: UserDefaultsKeys.backgroundImage.rawValue),
              let id = userDefaults.string(forKey: BackgroundImage.id.rawValue),
              let image = UIImage(data: data) else { return nil }
        return Image(image: image, isMyImage: true, id: id)
    }
}
