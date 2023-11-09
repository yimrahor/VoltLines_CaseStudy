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
    let allD = StationsAllData()
    var points: [PointInfo]?
    var selectedPointID: Int?
    var checkCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
            
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
            
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        configureMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        buttonListTrips.isHidden = true
    }
    
    func configureMapView() {
        mapView.removeAnnotations(mapView.annotations)
        allD.takeStationDatas() { [weak self] in
            self?.points = self?.allD.createPointStationsAndReturn()
            self?.createPointsOnMap()
        }
    }
    
    func createPointsOnMap() {
        guard let points = points else { return }
        for point in points {
            let (lat, lon) = point.coordinate.stringToLatitudeAndLongitude()
            let coordinateP = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinateP
            annotation.title = "\(String(point.tripCount)) Trips"
            mapView.addAnnotation(annotation)
        }
    }
    
    func controlCheckCoordinate() {
        if checkCoordinate != nil {
            guard let oldPointAnnotation = removeAnnotation() else { return }
            mapView.addAnnotation(oldPointAnnotation)
        }
       
        guard let selectedPointID = selectedPointID else { return }
        checkCoordinate = allD.findStationIDCoordinateToBeChecked(stationID: selectedPointID)
        guard let annnotationCheckPoint = removeAnnotation() else { return }
        mapView.addAnnotation(annnotationCheckPoint)
    }
    
    func removeAnnotation() -> MKAnnotation? {
        var annotation: MKAnnotation?
        
        mapView.annotations.forEach { [weak self] data in
            if data.coordinate == self?.checkCoordinate {
                self?.mapView.removeAnnotation(data)
                annotation = data
            }
        }
        return annotation
    }
    
    func createCircleArea(location: CLLocationCoordinate2D) {
        let circleCenter = location
        let circleRadius: CLLocationDistance = 600
        let circle = MKCircle(center: circleCenter, radius: circleRadius)
        mapView.addOverlay(circle)
    }
    
    @IBAction func listTripsButton(_ sender: UIButton) {
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
        if checkCoordinate == view.annotation!.coordinate {
            view.image = UIImage(named: "Completed")
        } else {
            view.image = UIImage(named: "SelectedPoint")
        }
        buttonListTrips.isHidden = false
        let coordinate = view.annotation?.coordinate
        points?.forEach({ data in
            let latitude = coordinate!.latitude
            let longitude = coordinate!.longitude
            let (lat,lon) = data.coordinate.stringToLatitudeAndLongitude()
            if (latitude == lat && lon == longitude) {
                selectedPointID = data.id
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if checkCoordinate == view.annotation!.coordinate {
            view.image = UIImage(named: "Completed")
        } else {
            view.image = UIImage(named: "Point")
        }
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
            
        if checkCoordinate == annotation.coordinate {
            annotationView?.image = UIImage(named: "Completed")
        } else {
            annotationView?.image = UIImage(named: "Point")
        }
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


