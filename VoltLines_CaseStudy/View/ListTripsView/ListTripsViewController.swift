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
        return cell
    }
    
 
    
}
