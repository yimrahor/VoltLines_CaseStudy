//
//  ListTripsViewController.swift
//  VoltLines_CaseStudy
//
//  Created by Yaşar Ebru İmrahor on 2.11.2023.
//

import UIKit

class ListTripsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var chosenStationId: Int?
    let listTripsData = AllData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitle()
        configureView()
        initDatas()
    }
    
    func initDatas() {
        listTripsData.takeStationDatas {
            guard let id = self.chosenStationId else { return }
            self.listTripsData.createTrips(id: id)
            self.tableView.reloadData()
        }
    }
    
    func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureTitle() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                spacer.width = 12
        
        let titleLabel = UILabel()
        titleLabel.text = "Trips"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.sizeToFit()
        
        let leftAlignedTitle = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItems = [spacer, leftAlignedTitle]
    }
}


extension ListTripsViewController: UITableViewDelegate {
    
}

extension ListTripsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTripsData.getTripsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTripCell", for: indexPath) as? ListTripsTableViewCell else { return UITableViewCell() }
        let trip = listTripsData.getTrip(row: indexPath.row)
        cell.busName.text = trip.busName
        cell.time.text = trip.time
        
        cell.cellProtocol = self
        cell.indexPath = indexPath
        return cell
    }
}

extension ListTripsViewController: ListTripsTableViewCellProtocol {
    func bookClicked(indexPath: IndexPath) {
        let trip = listTripsData.getTrip(row: indexPath.row)
        listTripsData.tripID = trip.id
        guard let stationID = chosenStationId else { return }
        listTripsData.stationID = stationID
        listTripsData.postTrip { isSuccess in
            if isSuccess {
                guard let mVC = self.presentingViewController as? MapViewController else { return }
                mVC.selectedPointID = stationID
                mVC.controlCheckCoordinate()
                self.dismiss(animated: true)
            } else {
                AlertHelper.shared.showAlert(currentVC: self, errorType: .tripError)
            }
        }
    }
}
