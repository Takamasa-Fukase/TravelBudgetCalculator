//
//  BudgetRegisterDateListCell.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 7/9/24.
//

import UIKit

class BudgetRegisterDateListCell: UITableViewCell {

    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            checkBoxImageView.image = UIImage(systemName: "checkmark.square.fill")
        }else {
            checkBoxImageView.image = UIImage(systemName: "square")
        }
    }
    
}
