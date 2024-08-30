//
//  ViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 30/8/24.
//

import UIKit

enum CurrencyType: String, CaseIterable {
    case euro = "EUR"
    case usDollar = "USD"
    // TODO: 通貨ごとのレートは可変なため、enum自体には持たせるべきではないので後から設定できるようにどうにかする
}

struct PaymentListItem {
    let title: String
    let amount: Double
    let currencyType: CurrencyType
}

class ViewController: UIViewController {
    let oneEuroToYenRate: Double = 170.00
    let oneUsDollarToYenRate: Double = 150.00
    
    let section1Items: [PaymentListItem] = [
        .init(title: "condisででかい水とタキスとチョコクッキー", amount: 4.15, currencyType: .euro),
        .init(title: "昼のレストランでサラダとパエリアなど", amount: 33.675, currencyType: .euro),
        .init(title: "タキスとか買ったかも？", amount: 4.94, currencyType: .euro),
        .init(title: "まりりんたちとご飯", amount: 21.14, currencyType: .euro)
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
        
        let rateValue: Double = {
            switch item.currencyType {
            case .euro:
                return oneEuroToYenRate
            case .usDollar:
                return oneUsDollarToYenRate
            }
        }()
        let yenAmount = item.amount * rateValue
        cell.yenDisplayLabel.text = "\(yenAmount)"
        return cell
    }
}
