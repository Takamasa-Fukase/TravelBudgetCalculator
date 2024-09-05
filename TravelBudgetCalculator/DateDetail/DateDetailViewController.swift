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
    let id: UUID
    var title: String
    var amount: Double
    var currencyType: CurrencyType
}

class DateDetailViewController: UIViewController {
    var toYenRate: Double = 0.15
    var dailyExpense: DailyExpense = .init(date: "", cityName: "", currency: .USD, expenseData: [])
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = dailyExpense.date
        cityNameLabel.text = dailyExpense.cityName
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
        let sectionData = dailyExpense.expenseData[section]
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
            self?.dailyExpense.expenseData[section].items.append(
                PaymentListItem(id: UUID(), title: "", amount: 0.0, currencyType: .ARA)
            )
            self?.tableView.reloadSections(IndexSet(integer: section), with: .none)
        }
        return sectionFooter
    }
}

extension DateDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dailyExpense.expenseData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyExpense.expenseData[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentListItemCell", for: indexPath) as! PaymentListItemCell
        let item = dailyExpense.expenseData[indexPath.section].items[indexPath.row]
        cell.id = item.id
        cell.titleTextField.text = "\(item.title)"
        cell.amountTextField.text = "\(item.amount)"
        cell.currencyLabel.text = "(\(item.currencyType.code))"
        cell.yenDisplayLabel.text = yenAmountText(amount: item.amount, toYenRate: toYenRate)
        cell.didEndEditingAmount = { [weak self] amount in
            cell.yenDisplayLabel.text = self?.yenAmountText(amount: amount, toYenRate: self?.toYenRate ?? 0.0)
            self?.dailyExpense.expenseData[indexPath.section].items[indexPath.row].amount = amount
            self?.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
        }
        cell.menuButtonTapped = { [weak self] id in
            let yenText = self?.yenAmountText(amount: item.amount, toYenRate: self?.toYenRate ?? 0.0) ?? ""
            let message = "項目名：\(item.title)\n現地通貨：\(item.amount)\n（\(yenText)）"
            let alert = UIAlertController(
                title: "項目を削除します",
                message: message,
                preferredStyle: .alert
            )
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            let delete = UIAlertAction(title: "削除", style: .destructive) { [weak self] _ in
                let sectionIndex = self?.dailyExpense.expenseData.firstIndex(where: { section in
                    section.items.contains(where: { $0.id == id })
                }) ?? 0
                let rowIndex = self?.dailyExpense.expenseData[sectionIndex].items.firstIndex(where: { $0.id == id }) ?? 0
                let selectedIndexPath = IndexPath(row: rowIndex, section: sectionIndex)
                
                print("対象のindexPath' \(selectedIndexPath), 削除前のデータ:\(self?.tableView.indexPathsForVisibleRows)")
                // 該当のデータを削除して画面を更新
                self?.dailyExpense.expenseData[selectedIndexPath.section].items.remove(at: selectedIndexPath.row)
                print("データをまず削除した")
                self?.tableView.deleteRows(at: [selectedIndexPath], with: .left)
                print("対象のindexPath' \(selectedIndexPath), 削除した後のデータ:\(self?.tableView.indexPathsForVisibleRows)")
            }
            alert.addAction(cancel)
            alert.addAction(delete)
            self?.present(alert, animated: true)
        }
        return cell
    }
}
