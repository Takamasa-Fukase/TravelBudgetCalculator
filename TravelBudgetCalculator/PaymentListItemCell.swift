//
//  PaymentListItemCell.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 30/8/24.
//

import UIKit

class PaymentListItemCell: UITableViewCell {
    var didSelectCurrency: ((CurrencyType) -> Void)?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencySelectionButton: UIButton!
    @IBOutlet weak var yenDisplayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCurrencySelectionButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCurrencySelectionButton() {
        let currencyOptionList = CurrencyType.allCases.map { item in
            return UIAction(title: item.rawValue, handler: { [weak self] _ in
                guard let didSelectCurrency = self?.didSelectCurrency else { return }
                didSelectCurrency(item)
            })
        }
        currencySelectionButton.menu = UIMenu(title: "現地通貨を選択", children: currencyOptionList)
        currencySelectionButton.showsMenuAsPrimaryAction = true
        currencySelectionButton.changesSelectionAsPrimaryAction = true
    }
}
