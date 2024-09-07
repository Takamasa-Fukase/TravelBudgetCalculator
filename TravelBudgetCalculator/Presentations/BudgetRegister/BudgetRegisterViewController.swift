//
//  BudgetRegisterViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 7/9/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol BudgetRegisterDelegate: AnyObject {
    func onRegistered()
}

class BudgetRegisterViewController: UIViewController {
    let disposeBag = DisposeBag()
    var travel: Travel = .init(id: UUID(), name: "", duration: "", dateList: [], budgetList: [])
    var section1DataList: [(title: String, text: String)] = [
        (title: "予算名", text: ""),
        (title: "予算金額", text: "")
    ]
    weak var delegate: BudgetRegisterDelegate?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "予算を登録"
        setupTableView()
        
        registerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                
                // 通貨が選択されていなかったらエラーを出す
                if self.section1DataList[0].text.isEmpty {
                    self.showError(title: "予算名を入力してください", message: "")
                    return
                }
                
                // レートが未入力だったらエラーを出す
                guard let doubleAmount = Double(self.section1DataList[1].text) else {
                    self.showError(title: "予算金額の値が不正です", message: "")
                    return
                }
                
                // 対象日が1つも選択されていなかったらエラーを出す
                guard let selectedIndexPaths = self.tableView.indexPathsForSelectedRows?.filter({ $0.section == 1 }),
                      !selectedIndexPaths.isEmpty else {
                    self.showError(title: "対象日を1つ以上選択してください", message: "")
                    return
                }
                let targetDates = selectedIndexPaths.map({ indexPath in
                    return self.travel.dateList[indexPath.row]
                })
                
                let budget = Budget(
                    name: self.section1DataList[0].text,
                    budgetAmount: doubleAmount,
                    targetDates: targetDates
                )
                
                // UserDefaultsに保存
                var editedData = UserDefaults.travels
                let index = editedData.firstIndex(where: { $0.id == self.travel.id }) ?? 0
                editedData[index].budgetList.append(budget)
                UserDefaults.travels = editedData
                                
                // 前の画面のリストを更新させるために通知
                self.delegate?.onRegistered()
                
                // 保存した内容を改めてアラートで表示
                self.showCompletionAlert(budget: budget, completion: {
                    self.dismiss(animated: true)
                })
            }).disposed(by: disposeBag)
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "BudgetRegisterInputFormCell", bundle: nil), forCellReuseIdentifier: "BudgetRegisterInputFormCell")
        tableView.register(UINib(nibName: "BudgetRegisterDateListCell", bundle: nil), forCellReuseIdentifier: "BudgetRegisterDateListCell")
        tableView.register(UINib(nibName: "BudgetRegisterDateListSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "BudgetRegisterDateListSectionHeader")
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset.bottom = 200
    }
    
    func showCompletionAlert(budget: Budget, completion: (@escaping () -> Void)) {
        let alert = UIAlertController(title: "予算を登録しました", message: "予算名：\(budget.name)\n予算金額：\(formatToManYen(budget.budgetAmount))", preferredStyle: .alert)
        let ok = UIAlertAction(title: "閉じる", style: .default, handler: { _ in
            completion()
        })
        alert.addAction(ok)
        present(alert, animated: true)
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

extension BudgetRegisterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BudgetRegisterDateListSectionHeader") as! BudgetRegisterDateListSectionHeader
            return sectionHeader
        }else {
            return UIView()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return section1DataList.count
        }else {
            return travel.dateList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        }else {
            return 36
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetRegisterInputFormCell", for: indexPath) as! BudgetRegisterInputFormCell
            let item = section1DataList[indexPath.row]
            // Delegateを親VCに設定
            cell.textField.delegate = self
            
            cell.titleLabel.text = item.title
            cell.textField.placeholder = item.title
            cell.textField.text = item.text
            
            cell.textField.rx.controlEvent(.editingDidEnd)
                .subscribe(onNext: { [weak self] in
                    guard let self = self else {return}
                    self.section1DataList[indexPath.row].text = cell.textField.text ?? ""
                    self.tableView.reloadData()
                }).disposed(by: cell.disposeBag)
            
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetRegisterDateListCell", for: indexPath) as! BudgetRegisterDateListCell
            let item = travel.dateList[indexPath.row]
            cell.dateLabel.text = item.date
            cell.cityNameLabel.text = item.cityName
            
            return cell
        }
    }
}

extension BudgetRegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
