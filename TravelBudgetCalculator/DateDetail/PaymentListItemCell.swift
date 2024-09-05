//
//  PaymentListItemCell.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 30/8/24.
//

import UIKit

class PaymentListItemCell: UITableViewCell {    
    var didEndEditingAmount: ((Double) -> Void) = {_ in }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var yenDisplayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupAmountTextField()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupAmountTextField() {
        amountTextField.delegate = self
        amountTextField.keyboardType = .numberPad
        amountTextField.returnKeyType = .done
        amountTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 0))
        amountTextField.rightViewMode = .always
    }
}

extension PaymentListItemCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let doubleAmount = Double(textField.text ?? "") else {
            // 不正な文字が入っていた場合はエラー表示する
            textField.text = ""
            yenDisplayLabel.text = "入力値が不正です"
            return
        }
        // 円表示を更新するために通知
        didEndEditingAmount(doubleAmount)
    }
}
