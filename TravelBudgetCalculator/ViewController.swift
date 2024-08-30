//
//  ViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 30/8/24.
//

import UIKit

struct PaymentListItem {
    var title: String
    var amount: Double
    var currencyType: CurrencyType
}

class ViewController: UIViewController {
    var currency: CurrencyType = .USD
    var toYenRate = 0.0
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
        cell.currencySelectionButton.setTitle(item.currencyType.code, for: .normal)
        cell.didSelectCurrency = { [weak self] type in
            // 元データをまず更新
            self?.section1Items[indexPath.row].currencyType = type
            
            // その後に該当のセルだけを再描画
            self?.tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)],
                                 with: .none)
        }
        let yenAmount = item.amount * toYenRate
        cell.yenDisplayLabel.text = "(\(String(format: "%.0f", ceil(yenAmount)))円)"
        return cell
    }
}
