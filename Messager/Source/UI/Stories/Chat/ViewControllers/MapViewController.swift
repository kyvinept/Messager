//
//  MapViewController.swift
//  Messager
//
//  Created by Silchenko on 14.11.2018.
//

import UIKit
import MapKit
import JGProgressHUD

protocol MapViewControllerDelegate: class {
    func didGetCurrentLocationButtonTapped(viewController: MapViewController)
    func didChoseCustomLocation(withLocation location: CLLocationCoordinate2D, viewController: MapViewController)
}

class MapViewController: UIViewController {
    
    @IBOutlet private weak var mapKit: MKMapView!
    private var location: CLLocationCoordinate2D?
    private var annotation: MKPointAnnotation?
    private var progress: JGProgressHUD?
    private var choseLocation: CLLocationCoordinate2D?
    var delegate: MapViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapKit.delegate = self
        
        if let location = location {
            set(currentLocation: location)
        } else {
            setChoseLocationButton()
            addTapGesture()
        }
    }
    
    func configure(location: CLLocationCoordinate2D) {
        self.location = location
    }
    
    func set(myLocation location: CLLocationCoordinate2D) {
        progress?.dismiss()
        
        set(currentLocation: location)
    }
    
    @IBAction private func myLocationButtonTapped(_ sender: Any) {
        progress = JGProgressHUD(style: .dark)
        progress?.show(in: self.view)
        
        delegate?.didGetCurrentLocationButtonTapped(viewController: self)
    }
    
    private func setChoseLocationButton() {
        let choseLocationButton = UIBarButtonItem(barButtonSystemItem: .action,
                                                               target: self,
                                                               action: #selector(MapViewController.choseLocationButtonTapped))
        self.navigationItem.rightBarButtonItem = choseLocationButton
    }
    
    @objc private func choseLocationButtonTapped() {
        if let choseLocation = choseLocation {
            delegate?.didChoseCustomLocation(withLocation: choseLocation, viewController: self)
        }
    }
    
    private func set(currentLocation location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.mapKit.setRegion(region, animated: true)
        
        annotation = MKPointAnnotation()
        annotation!.coordinate = location
        annotation!.subtitle = "User location"
        mapKit.addAnnotation(annotation!)
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
        choseLocation = locationCoordinate
        print(locationCoordinate)
        
        if let annotation = annotation {
            annotation.coordinate = locationCoordinate
        } else {
            annotation = MKPointAnnotation()
            annotation!.coordinate = locationCoordinate
            annotation!.subtitle = "User location"
            mapKit.addAnnotation(annotation!)
        }
    }
}
