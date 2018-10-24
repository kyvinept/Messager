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
    
    func save(email: String) {
        guard let data = email.data(using: String.Encoding.utf8) else { return }
        let getQuery: [String: Any] = query(with: data)
        let status = SecItemAdd(getQuery as CFDictionary, nil)
        guard status == errSecSuccess else { return }
    }
    
    func delete() {
        guard let email = load() else { return }
        guard let data = email.data(using: .utf8) else { return }
        let getQuery: [String: Any] = query(with: data)
        SecItemDelete(getQuery as CFDictionary)
    }
    
    func load() -> String? {
        let getquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: key,
                                       kSecReturnData as String: kCFBooleanTrue,
                                       kSecMatchLimit as String: kSecMatchLimitOne]
        var item: CFTypeRef?
        let status1 = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status1 == errSecSuccess else { return nil }
        if let data = item as? Data {
            return String(data: data, encoding: .utf8)
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
