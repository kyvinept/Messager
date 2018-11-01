//
//  String.swift
//  Messager
//
//  Created by Silchenko on 01.11.2018.
//

import UIKit

extension String {
    
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)!
    }
}
