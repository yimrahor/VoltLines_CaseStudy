//
//  AllData.swift
//  VoltLines_CaseStudy
//
//  Created by Yaşar Ebru İmrahor on 2.11.2023.
//

import Foundation

struct PointInfo {
    var id: Int
    var coordinate: String
    var tripCount: Int
}

class AllData {
    var trips = [Trip]()
    var points = [PointInfo]()
    var allDataResponse: StationListResponse?
    
    func takeStationDatas(complete: @escaping ()->()) {
        APIService.call.objectRequestJSON(url: "https://demo.voltlines.com/case-study/6/stations/", responseType: StationListResponse.self) { (result:Result<StationListResponse,Error>) in
            switch result {
            case .success(let data):
                self.allDataResponse = data
                complete()
            case .failure(let err):
                print(err)
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
}
