//
//  PaymentListItemCell.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 30/8/24.
//

import UIKit

class PaymentListItemCell: UITableViewCell {    
    var id: UUID = UUID()
    var didEndEditing: ((String, Double) -> Void) = { _, _  in }
    var menuButtonTapped: ((UUID) -> Void) = { _ in }
    var showError: ((String) -> Void) = { _ in }
    var toolBar = UIToolbar()

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var yenDisplayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        InputFormUtil.setupToolBar(toolBar, target: nil, action: #selector(done))
        setupTitleTextField()
        setupAmountTextField()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction private func menuButtonTapped(_ sender: Any) {
        menuButtonTapped(id)
    }
    
    func setupTitleTextField() {
        titleTextField.delegate = self
        amountTextField.returnKeyType = .done
    }
    
    func setupAmountTextField() {
        InputFormUtil.setupNumberTextField(amountTextField, delegate: self, toolBar: toolBar)
        amountTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 0))
        amountTextField.rightViewMode = .always
    }
    
    @objc func done() {
        contentView.endEditing(true)
    }
}

extension PaymentListItemCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let title = titleTextField.text ?? ""
        guard let doubleAmount = Double(amountTextField.text ?? "") else {
            showError("金額に不正な文字が入っていたので更新失敗")
            return
        }
        // 円表示を更新するために通知
        didEndEditing(title, doubleAmount)
    }
}
