//
//  RateSettingCell.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 6/9/24.
//

import UIKit
import RxSwift
import RxCocoa

class RateSettingCell: UITableViewCell {
    var disposeBag = DisposeBag()

    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
