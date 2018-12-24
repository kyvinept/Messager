//
//  SearchViewViewModel.swift
//  Messager
//
//  Created by Silchenko on 28.11.2018.
//

import UIKit

struct SearchViewViewModel {
    
    var placeholder: String
    var calendarIcon: UIImage?
    var searchToTopIcon: UIImage?
    var searchToBottomIcon: UIImage?
    var endInput: (String) -> ([Message])
    var showMessage: ((Message) -> ())?
    var willChangeMessage: ((Message) -> ())?
    var showCalendar: (() -> ())?
}
