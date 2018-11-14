//
//  LocationCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 14.11.2018.
//

import UIKit

struct LocationCellViewModel {
    
    var date: String
    var userImageUrl: String
    var location: CLLocationCoordinate2D
    var tapCell: ((CLLocationCoordinate2D) -> ())?
    
    init(date: Date, userImageUrl: String, location: CLLocationCoordinate2D, tapCell: ((CLLocationCoordinate2D) -> ())?) {
        self.date = date.toString(dateFormat: "HH:mm")
        self.userImageUrl = userImageUrl
        self.location = location
        self.tapCell = tapCell
    }
}
