//
//  DestinationListCell.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 31/8/24.
//

import UIKit

class DestinationListCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var estimatedAmountLabel: UILabel!
    @IBOutlet weak var restAmountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
