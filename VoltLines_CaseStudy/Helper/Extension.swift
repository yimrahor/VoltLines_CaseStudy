//
//  Extension.swift
//  VoltLines_CaseStudy
//
//  Created by Yaşar Ebru İmrahor on 6.11.2023.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension String {
    func stringToLatitudeAndLongitude() -> (Double, Double) {
        let fullCoordinate = self.components(separatedBy: ",")
        guard let latitude = Double(fullCoordinate[0]) else { return (0,0) }
        guard let longitude = Double(fullCoordinate[1]) else { return (0,0) }
        return (latitude, longitude)
    }
}
