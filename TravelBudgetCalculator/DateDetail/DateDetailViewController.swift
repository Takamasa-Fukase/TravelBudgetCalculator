//
//  DateDetailViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 31/8/24.
//

import UIKit
import RxSwift
import RxCocoa

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
    let disposeBag = DisposeBag()
    var activeTextField = BehaviorRelay<UIView?>(value: nil)
    var dailyExpense: DailyExpense = .init(date: "", cityName: "", currency: .USD, expenseData: [])
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = dailyExpense.date
        cityNameLabel.text = dailyExpense.cityName
        setupTableView()
        setRxKeyboardMovement(disposeBag: disposeBag,
                              scrollView: tableView,
                              textField: activeTextField.asObservable(),
                              view: view,
                              buttonConstraint: NSLayoutConstraint())
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "PaymentListItemCell", bundle: nil), forCellReuseIdentifier: "PaymentListItemCell")
        tableView.register(UINib(nibName: "DateDetailGenreSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "DateDetailGenreSectionHeader")
        tableView.register(UINib(nibName: "DateDetailGenreSectionFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "DateDetailGenreSectionFooter")
        tableView.keyboardDismissMode = .onDrag
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
        // MEMO: 後でitemごとに個別のレートに変更できる機能を作る場合は、合計をitemごとのレートで先に計算してから合算するように修正が必要
        sectionHeader.genreLabel.text = "\(genreName)：\(yenAmountText(amount: sumAmount, toYenRate: dailyExpense.currency.toYenRate))"
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DateDetailGenreSectionFooter") as! DateDetailGenreSectionFooter
        sectionFooter.addFormButtonTapped = { [weak self] in
            self?.dailyExpense.expenseData[section].items.append(
                PaymentListItem(id: UUID(), title: "", amount: 0, currencyType: self?.dailyExpense.currency ?? .USD)
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentListItemCell", for: indexPath) as! PaymentListItemCell
        let item = dailyExpense.expenseData[indexPath.section].items[indexPath.row]
        
        // Delegateを親VCに設定
        cell.titleTextField.delegate = self
        cell.amountTextField.delegate = self
        
        cell.id = item.id
        cell.titleTextField.text = "\(item.title)"
        cell.amountTextField.text = "\(item.amount)"
        // MARK: ここでは日付データが持っている共通通貨ではなく、item単体で保持されている通貨を使用する。
        // 今後、個別のセルの通貨を編集して保存する機能を作る予定があるので。（トルコでユーロを使ったみたいに。）
        cell.currencyLabel.text = "(\(item.currencyType.code))"
        cell.yenDisplayLabel.text = yenAmountText(amount: item.amount, toYenRate: item.currencyType.toYenRate)
        cell.didEndEditing = { [weak self] (title, amount) in
            self?.dailyExpense.expenseData[indexPath.section].items[indexPath.row].title = title
            self?.dailyExpense.expenseData[indexPath.section].items[indexPath.row].amount = amount
            // MEMO: セクションヘッダーに合計金額を表示しているため、セルだけでなくセクションを丸ごと更新している
            self?.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
        }
        cell.menuButtonTapped = { [weak self] id in
            guard let selectedItem = self?.dailyExpense.expenseData.first(where: { $0.items.contains(where: { $0.id == id }) })?.items.first(where: { $0.id == id }) else {
                self?.showError(message: "選択されたItemの取得に失敗")
                return
            }
            let yenText = self?.yenAmountText(amount: selectedItem.amount, toYenRate: selectedItem.currencyType.toYenRate) ?? ""
            let message = "項目名：\(selectedItem.title)\n現地通貨：\(selectedItem.amount)\n（\(yenText)）"
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
                // 該当のデータを削除して画面を更新
                self?.dailyExpense.expenseData[selectedIndexPath.section].items.remove(at: selectedIndexPath.row)
                self?.tableView.deleteRows(at: [selectedIndexPath], with: .left)
            }
            alert.addAction(cancel)
            alert.addAction(delete)
            self?.present(alert, animated: true)
        }
        cell.showError = { [weak self] message in
            self?.showError(message: message)
        }
        return cell
    }
}

extension DateDetailViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField.accept(textField)
        return true
    }
}
