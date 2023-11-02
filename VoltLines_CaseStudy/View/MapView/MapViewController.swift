//
//  ViewController.swift
//  VoltLines_CaseStudy
//
//  Created by Yaşar Ebru İmrahor on 2.11.2023.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let locationAlert = UIAlertAction(title: "Open", style: .default) { _ in
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }
    
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
        
        let allD = AllData()
        allD.takeStationDatas()
    }
    
    func createCircleArea(location: CLLocationCoordinate2D) {
        let circleCenter = location
        let circleRadius: CLLocationDistance = 600 // Yarıçapı metre cinsinden belirtin
        let circle = MKCircle(center: circleCenter, radius: circleRadius)
        mapView.addOverlay(circle)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    // Call user location changed
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            createCircleArea(location: center)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            mapView.setRegion(region, animated: true)
        }
    }
 // if location error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.3)
            circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
            circleRenderer.lineWidth = 2
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied, .restricted:
            AlertHelper.shared.showAlert(currentVC: self, errorType: .locationError(locationAlert))
        case .authorizedWhenInUse:
            print("When user select option Allow While Using App or Allow Once")
        default:
            print("Default")
        }
    }
}
