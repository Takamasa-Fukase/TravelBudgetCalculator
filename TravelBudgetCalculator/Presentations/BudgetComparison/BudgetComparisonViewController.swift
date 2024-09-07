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
            print("アンラップ失敗")
            return cell
        }
        print(1)
        let item = travel.budgetList[indexPath.row]
        cell.budgetNameLabel.text = item.name
        cell.bedgetAmountLabel.text = "予算：\(item.budgetAmount)円"
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
        cell.usedAmountLabel.text = "出費：\(usedAmount)円"
        cell.restAmountLabel.text = "残り：\(restAmount)円"

        return cell
    }
}
