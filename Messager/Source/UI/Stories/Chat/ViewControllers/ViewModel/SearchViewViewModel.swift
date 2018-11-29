//
//  SearchViewViewModel.swift
//  Messager
//
//  Created by Silchenko on 28.11.2018.
//

import UIKit

struct SearchViewViewModel {
    
    var endInput: (String) -> ([Message])
    var showMessage: ((Message) -> ())?
    var willChangeMessage: ((Message) -> ())?
    var showCalendar: (() -> ())?
}
