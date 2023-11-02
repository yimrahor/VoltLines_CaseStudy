//
//  ListTripsTableViewCell.swift
//  VoltLines_CaseStudy
//
//  Created by Yaşar Ebru İmrahor on 2.11.2023.
//

import UIKit

protocol ListTripsTableViewCellProtocol: AnyObject {
    func bookClicked(indexPath: IndexPath)
}

class ListTripsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var busName: UILabel!
    @IBOutlet weak var time: UILabel!
    
    weak var cellProtocol: ListTripsTableViewCellProtocol?
    var indexPath: IndexPath?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func bookButtonTapped(_ sender: Any) {
        cellProtocol?.bookClicked(indexPath: indexPath!)
    }
    

}
