//
//  KeychainManager.swift
//  Messager
//
//  Created by Silchenko on 24.10.2018.
//

import UIKit

class KeychainManager {
    
    private let key = "Messager.Email"
    
    private func query(with email: Data) -> [String: Any] {
        return [kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: email]
    }
    
    func getCurrentUser() -> User? {
        guard let query = load() else { return nil }
        return User(email: query["email"] as! String,
                     name: query["name"] as! String,
                 password: nil,
                       id: query["id"] as! String,
                userToken: nil,
                 imageUrl: query["image"] as! String)
    }
    
    func save(email: String, id: String, name: String, imageUrl: String) {
        delete()
        let saveData = ["email": email, "id": id, "name": name, "image": imageUrl] as [String : Any]
        let data = NSKeyedArchiver.archivedData(withRootObject: saveData)
        let getQuery: [String: Any] = query(with: data)
        let res = SecItemAdd(getQuery as CFDictionary, nil)
        print(res)
    }
    
    func delete() {
        guard let objects = load() else { return }
        let data = NSKeyedArchiver.archivedData(withRootObject: objects)
        let getQuery: [String: Any] = query(with: data)
        SecItemDelete(getQuery as CFDictionary)
    }
    
    func load() -> [String : Any]? {
        let getquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: key,
                                       kSecReturnData as String: kCFBooleanTrue,
                                       kSecMatchLimit as String: kSecMatchLimitOne]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else { return nil }
        if let data = item as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : Any]
        }
        return nil
    }
    
    func hasEmail() -> Bool {
        if load() != nil {
            return true
        }
        return false
    }
}
