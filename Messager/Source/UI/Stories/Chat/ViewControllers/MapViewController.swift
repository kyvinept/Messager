//
//  MapViewController.swift
//  Messager
//
//  Created by Silchenko on 14.11.2018.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet private weak var mapKit: MKMapView!
    private var location: CLLocationCoordinate2D!

    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentLocation()
    }
    
    func configure(location: CLLocationCoordinate2D) {
        self.location = location
    }
    
    private func setCurrentLocation() {
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.mapKit.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.subtitle = "User location"
        mapKit.addAnnotation(annotation)
    }
}
