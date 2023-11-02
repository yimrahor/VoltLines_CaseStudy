//
//  AllData.swift
//  VoltLines_CaseStudy
//
//  Created by Yaşar Ebru İmrahor on 2.11.2023.
//

import Foundation

class AllData {
    
    func takeStationDatas() {
        APIService.call.objectRequestJSON(url: "https://demo.voltlines.com/case-study/6/stations/", responseType: StationListResponse.self) { data in
            print(data)
        }
    }
}
