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
    
    func getCurrentUser() -> User {
        let query = load()!
        return User(email: query["email"]!, name: query["name"]!, password: nil, id: query["id"]!, userToken: nil)
    }
    
    func save(email: String, id: String, name: String) {
        let saveData = ["email": email, "id": id, "name": name]
        let data = NSKeyedArchiver.archivedData(withRootObject: saveData)
        let getQuery: [String: Any] = query(with: data)
        let status = SecItemAdd(getQuery as CFDictionary, nil)
        guard status == errSecSuccess else { return }
    }
    
    func delete() {
        guard let objects = load() else { return }
        let data = NSKeyedArchiver.archivedData(withRootObject: objects)
        let getQuery: [String: Any] = query(with: data)
        SecItemDelete(getQuery as CFDictionary)
    }
    
    func load() -> [String : String]? {
        let getquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: key,
                                       kSecReturnData as String: kCFBooleanTrue,
                                       kSecMatchLimit as String: kSecMatchLimitOne]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else { return nil }
        if let data = item as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : String]
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
