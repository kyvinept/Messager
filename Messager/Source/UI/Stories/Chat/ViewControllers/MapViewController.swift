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
    private var location: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapKit.delegate = self
        
        if let location = location {
            set(currentLocation: location)
        } else {
            addTapGesture()
        }
    }
    
    func configure(location: CLLocationCoordinate2D) {
        self.location = location
    }
    
    private func set(currentLocation location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.mapKit.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.subtitle = "User location"
        mapKit.addAnnotation(annotation)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MapViewController.didTappedOnMap))
        mapKit.addGestureRecognizer(tap)
    }
    
    @objc private func didTappedOnMap(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: mapKit)
        let locationCoordinate = mapKit.convert(touchLocation, toCoordinateFrom: mapKit)
        print(locationCoordinate)
    }
}
