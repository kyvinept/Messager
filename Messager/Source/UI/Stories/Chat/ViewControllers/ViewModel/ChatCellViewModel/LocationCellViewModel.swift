//
//  LocationCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 14.11.2018.
//

import UIKit

struct LocationCellViewModel: CustomViewModel {
    
    var locationImage: UIImage?
    var locationImageSize: CGSize
    var date: String
    var userImageUrl: String
    var location: CLLocationCoordinate2D
    var tapCell: ((CLLocationCoordinate2D) -> ())?
    
    init(locationImage: UIImage?, locationImageSize: CGSize, date: Date, userImageUrl: String, location: CLLocationCoordinate2D, tapCell: ((CLLocationCoordinate2D) -> ())?) {
        self.locationImage = locationImage
        self.locationImageSize = locationImageSize
        self.date = date.toString(dateFormat: "HH:mm")
        self.userImageUrl = userImageUrl
        self.location = location
        self.tapCell = tapCell
    }
}
