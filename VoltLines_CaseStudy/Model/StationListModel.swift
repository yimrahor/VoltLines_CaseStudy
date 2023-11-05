//
//  StationListResponse.swift
//  VoltLines_CaseStudy
//
//  Created by Yaşar Ebru İmrahor on 2.11.2023.
//

import Foundation

// MARK: - StationList
struct StationList: Codable {
    let centerCoordinates: String?
    let id: Int?
    let name: String?
    let trips: [Trip]?
    let tripsCount: Int?

    enum CodingKeys: String, CodingKey {
        case centerCoordinates = "center_coordinates"
        case id, name, trips
        case tripsCount = "trips_count"
    }
}

// MARK: - Trip
struct Trip: Codable {
    let busName: String?
    let id: Int?
    let time: String?

    enum CodingKeys: String, CodingKey {
        case busName = "bus_name"
        case id, time
    }
}

typealias StationListResponse = [StationList]
