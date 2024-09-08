//
//  BudgetComparisonCell.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 7/9/24.
//

import UIKit
import GTProgressBar

class BudgetComparisonCell: UITableViewCell {
    
    @IBOutlet weak var budgetNameLabel: UILabel!
    @IBOutlet weak var durationCountLabel: UILabel!
    @IBOutlet weak var progressBar: GTProgressBar!
    @IBOutlet weak var usedAmountLabel: UILabel!
    @IBOutlet weak var restAmountLabel: UILabel!
    @IBOutlet weak var bedgetAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
