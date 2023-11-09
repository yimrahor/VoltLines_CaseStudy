//
//  AllData.swift
//  VoltLines_CaseStudy
//
//  Created by Yaşar Ebru İmrahor on 2.11.2023.
//

import Foundation
import CoreLocation

final class StationsAllData {
    var trips = [Trip]()
    var points = [PointInfo]()
    var allDataResponse: StationListResponse?
    var stationID: Int?
    var tripID: Int?
    
    func takeStationDatas(complete: @escaping ()->()) {
        APIService.call.objectRequestJSON(url: "\(BASE_URL)/stations/", responseType: StationListResponse.self) { (result:Result<StationListResponse,Error>) in
            switch result {
            case .success(let data):
                self.allDataResponse = data
                complete()
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func postTrip(tripID: Int, stationID: Int, complete: @escaping (Bool)->()) {
        APIService.call.objectPostRequest(url: "\(BASE_URL)/stations/\(String(stationID))/trips/\(String(tripID))", responseType: Trip.self) { bool in
            if bool {
                complete(true)
            } else {
                complete(false)
            }
        }
    }
    
    func createPointStationsAndReturn() -> [PointInfo] {
        allDataResponse?.forEach({ data in
            guard let id = data.id, let coordinate = data.centerCoordinates, let tripCount = data.tripsCount else { return }
            let point = PointInfo(id: id, coordinate: coordinate, tripCount: tripCount)
            points.append(point)
        })
        return points
    }
    
    func createTrips(id: Int) {
        guard let allDataResponse = allDataResponse else { return }
        allDataResponse.forEach({ data in
            if (data.id == id) {
                guard let listTrips = data.trips else { return }
                self.trips = listTrips
            }
        })
    }
    
    func getTripsCount() -> Int {
        return trips.count
    }
    
    func getTrip(row: Int) -> Trip {
        return trips[row]
    }
    
    func findStationIDCoordinateToBeChecked(stationID: Int) -> CLLocationCoordinate2D  {
        var coordinate2D: CLLocationCoordinate2D?
        allDataResponse?.forEach({ data in
            if data.id == stationID {
                guard let coordinate = data.centerCoordinates else { return }
                let (latitude, longitude) = coordinate.stringToLatitudeAndLongitude()
                coordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
        })
        guard let coordinate2D = coordinate2D else { return CLLocationCoordinate2D() }
        return coordinate2D
    }
}
