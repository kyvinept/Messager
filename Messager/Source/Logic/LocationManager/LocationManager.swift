//
//  LocationManager.swift
//  Messager
//
//  Created by Silchenko on 13.11.2018.
//

import UIKit

class LocationManager: NSObject {
    
    private var updateLocation: ((CLLocationCoordinate2D) -> ())?
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func getCurrentLocation(successBlock: @escaping (CLLocationCoordinate2D) -> (), errorBlock: @escaping () -> ()) {
        updateLocation = successBlock
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else { return }
        updateLocation?(coordinate)
        locationManager.stopUpdatingLocation()
        updateLocation = nil
    }
}
