//
//  ViewController.swift
//  VoltLines_CaseStudy
//
//  Created by Yaşar Ebru İmrahor on 2.11.2023.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 2
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        

        // 3
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
}

extension ViewController: MKMapViewDelegate {
    // Call user location changed
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                mapView.setRegion(region, animated: true)
            }
        }
        
        // if location error
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error: \(error.localizedDescription)")
        }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("When user did not yet determined")
        case .denied, .restricted:
            print("When user select option Dont't Allow")
        case .authorizedWhenInUse:
            print("When user select option Allow While Using App or Allow Once")
        default:
            print("Default")
        }
    }
}
