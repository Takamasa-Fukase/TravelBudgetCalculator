//
//  DateDetailViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 31/8/24.
//

import UIKit

struct PaymentListSection {
    let paymentType: PaymentType
    var items: [PaymentListItem]
    
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

class DateDetailViewController: UIViewController {
    /*
     - USD：144.93円
     - ARA：0.15円
     - COP：0.035円
     - MXN：7.28円
     */
    var toYenRate: Double = 0.15
    
    var date: String = ""
    var cityName: String = ""
    var data: [PaymentListSection] = [
        PaymentListSection(
            paymentType: .transportation,
            items: []
        ),
        PaymentListSection(
            paymentType: .food,
            items: []
        ),
        PaymentListSection(
            paymentType: .other,
            items: []
        )
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "PaymentListItemCell", bundle: nil), forCellReuseIdentifier: "PaymentListItemCell")
        tableView.register(UINib(nibName: "DateDetailGenreSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "DateDetailGenreSectionHeader")
        tableView.register(UINib(nibName: "DateDetailGenreSectionFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "DateDetailGenreSectionFooter")
    }
    
    func yenAmountText(amount: Double, toYenRate: Double) -> String {
        let yenAmount = amount * toYenRate
        return "\(String(format: "%.0f", ceil(yenAmount)))円"
    }
}

extension DateDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DateDetailGenreSectionHeader") as! DateDetailGenreSectionHeader
        let sectionData = data[section]
        let genreName = sectionData.paymentType.rawValue
        var sumAmount: Double = 0.0
        sectionData.items.forEach({ item in
            sumAmount += item.amount
        })
        sectionHeader.genreLabel.text = "\(genreName)：\(yenAmountText(amount: sumAmount, toYenRate: toYenRate))"
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DateDetailGenreSectionFooter") as! DateDetailGenreSectionFooter
        // TODO: 後で、画面というかセルに保持されている通貨を代入するように変更する
        sectionFooter.addFormButtonTapped = { [weak self] in
            self?.data[section].items.append(
                PaymentListItem(title: "", amount: 0.0, currencyType: .ARA)
            )
            self?.tableView.reloadSections(IndexSet(integer: section), with: .none)
        }
        return sectionFooter
    }
}

extension DateDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentListItemCell", for: indexPath) as! PaymentListItemCell
        let item = data[indexPath.section].items[indexPath.row]
        cell.titleTextField.text = "\(item.title)"
        cell.amountTextField.text = "\(item.amount)"
        cell.currencyLabel.text = "(\(item.currencyType.code))"
        cell.yenDisplayLabel.text = yenAmountText(amount: item.amount, toYenRate: toYenRate)
        cell.didEndEditingAmount = { [weak self] amount in
            cell.yenDisplayLabel.text = self?.yenAmountText(amount: amount, toYenRate: self?.toYenRate ?? 0.0)
            self?.data[indexPath.section].items[indexPath.row].amount = amount
            self?.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
        }
        return cell
    }
}
