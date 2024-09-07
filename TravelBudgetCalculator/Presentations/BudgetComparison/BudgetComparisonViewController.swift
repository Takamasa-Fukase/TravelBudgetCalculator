//
//  BudgetComparisonViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 7/9/24.
//

import UIKit
import RxSwift
import RxCocoa

class BudgetComparisonViewController: UIViewController {
    let disposeBag = DisposeBag()
    var travelId: UUID = UUID()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "予算管理"
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "BudgetComparisonCell", bundle: nil), forCellReuseIdentifier: "BudgetComparisonCell")
        tableView.contentInset.bottom = 200
    }
    
    // 例: 36111円 -> 3.7万円 の表示にする。少数2桁以下は四捨五入
    func formatToManYen(_ amount: Double) -> String {
        // 金額を「万円」に変換
        let manYen = amount / 10000.0
        
        // 少数第2位で四捨五入
        let roundedManYen = round(manYen * 10) / 10.0
        
        // 結果をフォーマットして文字列に変換
        return String(format: "%.1f万円", roundedManYen)
    }
}

extension BudgetComparisonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        var editedData = UserDefaults.registeredCurrencies
//        editedData.remove(at: indexPath.row)
//        UserDefaults.registeredCurrencies = editedData
//        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaults.travels.first(where: { $0.id == travelId })?.budgetList.count ?? 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetComparisonCell", for: indexPath) as! BudgetComparisonCell
        guard let travel = UserDefaults.travels.first(where: { $0.id == travelId }) else {
            return cell
        }
        let item = travel.budgetList[indexPath.row]
        cell.budgetNameLabel.text = item.name
        cell.bedgetAmountLabel.text = "予算：\(formatToManYen(item.budgetAmount))"
        var usedAmount: Double = 0.0
        travel.dateList.forEach({ date in
            date.expenseData.forEach({ genre in
                genre.items.forEach({ payment in
                    let yenAmount = payment.amount * payment.currencyType.toYenRate
                    usedAmount += yenAmount
                })
            })
        })
        let restAmount = item.budgetAmount - usedAmount
        cell.usedAmountLabel.text = "出費：\(formatToManYen(usedAmount))"
        cell.restAmountLabel.text = "残り：\(formatToManYen(restAmount))"

        return cell
    }
}
