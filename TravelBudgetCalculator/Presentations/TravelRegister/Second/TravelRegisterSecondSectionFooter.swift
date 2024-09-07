//
//  TravelRegisterSecondSectionFooter.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 7/9/24.
//

import UIKit
import RxSwift
import RxCocoa

class TravelRegisterSecondSectionFooter: UITableViewHeaderFooterView {
    var disposeBag = DisposeBag()

    @IBOutlet weak var registerButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
