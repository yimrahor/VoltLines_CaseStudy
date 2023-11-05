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

    @IBOutlet weak var buttonListTrips: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    let locationAlertAction = UIAlertAction(title: "Open", style: .default) { _ in
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }
    
    var locationManager: CLLocationManager?
    let allD = AllData()
    var points: [PointInfo]?
    var selectedPointID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonListTrips.isHidden = true
        
        // 2
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        

        // 3
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        allD.takeStationDatas() { () in
            self.points = self.allD.createPointStationsAndReturn()
            self.createPointsOnMap()
        }
    }
    
    func createPointsOnMap() {
        guard let points = points else { return }
        for point in points {
            let fullCoordinate = point.coordinate.components(separatedBy: ",")
            guard let latitude = Double(fullCoordinate[0]) else { return }
            guard let longitude = Double(fullCoordinate[1]) else { return }
            let annotation = MKPointAnnotation()
            let coordinateP = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            print(coordinateP)
            annotation.coordinate = coordinateP
            annotation.title = "\(String(point.tripCount)) Trips"
            mapView.addAnnotation(annotation)
        }
    }
    
    func createCircleArea(location: CLLocationCoordinate2D) {
        let circleCenter = location
        let circleRadius: CLLocationDistance = 600 // Yarıçapı metre cinsinden belirtin
        let circle = MKCircle(center: circleCenter, radius: circleRadius)
        mapView.addOverlay(circle)
    }
    
    
    
    @IBAction func istTripsButton(_ sender: UIButton) {
        print("selam")
        let storyboard = UIStoryboard(name: "ListTripsView", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "ListTripsViewController") as? UINavigationController {
            vc.modalPresentationStyle = .formSheet
            if let listTripsVC = vc.viewControllers.first as? ListTripsViewController {
                listTripsVC.chosenStationId = selectedPointID
            }
            
            
            present(vc, animated: true)
        }
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

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.detailCalloutAccessoryView?.frame.size.height = 100
        view.image = UIImage(named: "SelectedPoint")
        buttonListTrips.isHidden = false
        let coordinate = view.annotation?.coordinate
        points?.forEach({ data in
            let latitude = String(coordinate!.latitude)
            let longitude = String(coordinate!.longitude)
            let fullCoordinate = data.coordinate.components(separatedBy: ",")
            let lat = fullCoordinate[0]
            let long = fullCoordinate[1]
            if (latitude == lat && long == longitude) {
                selectedPointID = data.id
            }
        })
        }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: "Point")
        buttonListTrips.isHidden = true
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let reuseIdentifier = "CustomAnnotationView"
        
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            } else {
                annotationView?.annotation = annotation
            }
                
            annotationView?.image = UIImage(named: "Point")
            annotationView?.canShowCallout = true
            
            return annotationView
        }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied, .restricted:
            AlertHelper.shared.showAlert(currentVC: self, errorType: .locationError(locationAlertAction))
        case .authorizedWhenInUse:
            print("When user select option Allow While Using App or Allow Once")
        default:
            print("Default")
        }
    }
}


