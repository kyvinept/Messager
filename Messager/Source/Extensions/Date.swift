//
//  Date.swift
//  Messager
//
//  Created by Silchenko on 01.11.2018.
//

import UIKit

extension Date {
    
    func toString(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: self)
        return date
    }
}
