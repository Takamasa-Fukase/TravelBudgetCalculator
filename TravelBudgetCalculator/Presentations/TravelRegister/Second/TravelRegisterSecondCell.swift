//
//  TravelRegisterSecondCell.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 7/9/24.
//

import UIKit
import RxSwift
import RxCocoa
class TravelRegisterSecondCell: UITableViewCell {
    var disposeBag = DisposeBag()
    let selectedCurrencyRelay = PublishRelay<CurrencyType>()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var currencySelectionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cityNameTextField.returnKeyType = .done
        setupCurrencySelectionButton()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func setupCurrencySelectionButton() {
        let currencyOptionList = UserDefaults.registeredCurrencies.map { item in
            return UIAction(title: item.type.rawValue, handler: { [weak self] _ in
                guard let self = self else { return }
                // 選択された通貨を変数に保持
                self.selectedCurrencyRelay.accept(item.type)
            })
        }
        // 初期選択される通貨を変数に保持
        selectedCurrencyRelay.accept(UserDefaults.registeredCurrencies.first?.type ?? .USD)
        
        currencySelectionButton.menu = UIMenu(title: "通貨を選択", children: currencyOptionList)
        currencySelectionButton.showsMenuAsPrimaryAction = true
        currencySelectionButton.changesSelectionAsPrimaryAction = true
    }
}
