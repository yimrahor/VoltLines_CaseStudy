//
//  ListTripsViewController.swift
//  VoltLines_CaseStudy
//
//  Created by Yaşar Ebru İmrahor on 2.11.2023.
//

import UIKit

class ListTripsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTitle()
        configureView()
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTripCell", for: indexPath) as? ListTripsTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
 
    
}
