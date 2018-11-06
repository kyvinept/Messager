//
//  String.swift
//  Messager
//
//  Created by Silchenko on 01.11.2018.
//

import UIKit

extension String {
    
    func toDate(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.date(from: self)
    }
}
