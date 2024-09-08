//
//  BudgetComparisonViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 7/9/24.
//

import UIKit
import RxSwift
import RxCocoa
import GTProgressBar

class BudgetComparisonViewController: UIViewController {
    let disposeBag = DisposeBag()
    var travel: Travel = .init(id: UUID(), name: "", duration: "", dateList: [], budgetList: [])

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toBudgetRegisterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "予算管理"
        
        // TODO: 今だと結局前の画面から遷移時に一度は正しいtravelIdが含まれてるtravelを渡す必要がある。
        // 遷移時に一度UserDefaultsから最新データを取得して変数に保持する
        if let travel = UserDefaults.travels.first(where: { $0.id == travel.id }) {
            self.travel = travel
        }
        
        setupTableView()
        
        toBudgetRegisterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                let vc = UIStoryboard(name: "BudgetRegisterViewController", bundle: nil).instantiateInitialViewController() as! BudgetRegisterViewController
                vc.travel = self.travel
                vc.delegate = self
                let navi = UINavigationController(rootViewController: vc)
                navi.modalPresentationStyle = .pageSheet
                self.present(navi, animated: true)
            }).disposed(by: disposeBag)
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
        // まずこの画面で保持している旅行情報から削除
        travel.budgetList.remove(at: indexPath.row)
        
        // そのデータをUserDefaultsに保存
        // UserDefaultsから削除
        var editedData = UserDefaults.travels
        let index = editedData.firstIndex(where: { $0.id == travel.id }) ?? 0
        editedData[index] = travel
        UserDefaults.travels = editedData
        
        // 画面を更新
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travel.budgetList.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetComparisonCell", for: indexPath) as! BudgetComparisonCell
        let item = travel.budgetList[indexPath.row]
        cell.budgetNameLabel.text = item.name
        cell.bedgetAmountLabel.text = "予算：\(formatToManYen(item.budgetAmount))"
        
        // 対象日をループで回して、出費額の日本円換算後の金額を加算していき合計を求める
        var usedAmount: Double = 0.0
        item.targetDateIds.forEach({ dateId in
            guard let date = travel.dateList.first(where: { $0.id == dateId }) else {
                return
            }
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
        var progress = usedAmount / item.budgetAmount
        if progress > 1 {
            progress = 1
        }
        cell.progressBar.progress = progress

        if restAmount >= 0 {
            cell.restAmountLabel.textColor = .systemGreen
            cell.progressBar.barFillColor = .systemBlue
        }else {
            cell.restAmountLabel.textColor = .systemRed
            cell.progressBar.barFillColor = .systemRed
        }

        return cell
    }
}

extension BudgetComparisonViewController: BudgetRegisterDelegate {
    func onRegistered() {
        // UserDefaultsに保存された更新後のデータ取得して変数に保持し直す
        guard let travel = UserDefaults.travels.first(where: { $0.id == travel.id }) else {
            return
        }
        self.travel = travel
        tableView.reloadData()
    }
}
