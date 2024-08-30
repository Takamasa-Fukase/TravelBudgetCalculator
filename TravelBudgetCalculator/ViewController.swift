//
//  ViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 30/8/24.
//

import UIKit

struct PaymentListSection {
    let paymentType: PaymentType
    let items: [PaymentListItem]
    
    enum PaymentType: String, CaseIterable {
        case transportation = "交通費"
        case food = "食費"
        case other = "その他"
    }
}

struct PaymentListItem {
    var title: String
    var amount: Double
    var currencyType: CurrencyType
}

class ViewController: UIViewController {
    var currency: CurrencyType = .EUR
    var toYenRate = 170.0
    var section1Items: [PaymentListItem] = [
        .init(title: "condisででかい水とタキスとチョコクッキー", amount: 4.15, currencyType: .EUR),
        .init(title: "昼のレストランでサラダとパエリアなど", amount: 33.675, currencyType: .EUR),
        .init(title: "タキスとか買ったかも？", amount: 4.94, currencyType: .EUR),
        .init(title: "まりりんたちとご飯", amount: 21.14, currencyType: .EUR)
    ]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "PaymentListItemCell", bundle: nil), forCellReuseIdentifier: "PaymentListItemCell")
    }
    
    func yenAmountText(amount: Double, toYenRate: Double) -> String {
        let yenAmount = amount * toYenRate
        return "\(String(format: "%.0f", ceil(yenAmount)))円"
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section1Items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentListItemCell", for: indexPath) as! PaymentListItemCell
        let item = section1Items[indexPath.row]
        cell.titleTextField.text = "\(item.title)"
        cell.amountTextField.text = "\(item.amount)"
        cell.currencyLabel.text = "(\(item.currencyType.code))"
        cell.yenDisplayLabel.text = yenAmountText(amount: item.amount, toYenRate: toYenRate)
        cell.didEndEditingAmount = { [weak self] amount in
            cell.yenDisplayLabel.text = self?.yenAmountText(amount: amount, toYenRate: self?.toYenRate ?? 0.0)
        }
        return cell
    }
}
