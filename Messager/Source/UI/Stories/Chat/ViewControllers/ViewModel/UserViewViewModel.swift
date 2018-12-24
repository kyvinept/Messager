//
//  UserViewViewModel.swift
//  Messager
//
//  Created by Silchenko on 24.12.2018.
//

import UIKit

struct UserViewViewModel {
    var userName: String
    var userImageUrl: String
    var backButtonTapped: (() -> ())?
    var searchButtonTapped: (() -> ())?
    var userProfileTapped: (() -> ())?
}
