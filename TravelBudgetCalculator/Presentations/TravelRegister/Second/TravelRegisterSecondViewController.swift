//
//  TravelRegisterSecondViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 7/9/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol TravelRegisterDelegate: AnyObject {
    func onRegistered()
}

class TravelRegisterSecondViewController: UIViewController {
    let disposeBag = DisposeBag()
    var activeTextField = BehaviorRelay<UIView?>(value: nil)
    var travel: Travel = .init(id: UUID(), name: "", duration: "", imageData: nil, dateList: [], budgetList: [])
    weak var delegate: TravelRegisterDelegate?
    
    @IBOutlet weak var tableView: TouchesBeganTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "旅行を登録（2/2）"

        setupTableView()
        setRxKeyboardMovement(disposeBag: disposeBag,
                              scrollView: tableView,
                              textField: activeTextField.asObservable(),
                              view: view,
                              buttonConstraint: NSLayoutConstraint())
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "TravelRegisterSecondCell", bundle: nil), forCellReuseIdentifier: "TravelRegisterSecondCell")
        tableView.register(UINib(nibName: "TravelRegisterSecondSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "TravelRegisterSecondSectionHeader")
        tableView.register(UINib(nibName: "TravelRegisterSecondSectionFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "TravelRegisterSecondSectionFooter")
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset.bottom = 200
    }
    
    func showCompletionAlert(completion: (@escaping () -> Void)) {
        let alert = UIAlertController(title: "旅行を登録しました", message: "タイトル：\(travel.name)\n期間：\(travel.duration)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "閉じる", style: .default, handler: { _ in
            completion()
        })
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

extension TravelRegisterSecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TravelRegisterSecondSectionHeader") as! TravelRegisterSecondSectionHeader
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TravelRegisterSecondSectionFooter") as! TravelRegisterSecondSectionFooter
        sectionFooter.registerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                
                // 各日の通貨に合わせて３ジャンルの出費データの初期値を生成
                self.travel.dateList.enumerated().forEach({ (index, item) in
                    self.travel.dateList[index].expenseData = [
                        .init(paymentType: .transportation, items: [
                            .init(id: UUID(), title: "", amount: 0, currencyType: item.currency)
                        ]),
                        .init(paymentType: .food, items: [
                            .init(id: UUID(), title: "", amount: 0, currencyType: item.currency)
                        ]),
                        .init(paymentType: .other, items: [
                            .init(id: UUID(), title: "", amount: 0, currencyType: item.currency)
                        ])
                    ]
                })
                
                UserDefaults.travels = UserDefaults.travels + [self.travel]
                
                // 前の画面のリストを更新させるために通知
                self.delegate?.onRegistered()
                
                // 保存した内容を改めてアラートで表示
                self.showCompletionAlert(completion: {
                    self.dismiss(animated: true)
                })
            }).disposed(by: sectionFooter.disposeBag)
        return sectionFooter
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travel.dateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelRegisterSecondCell", for: indexPath) as! TravelRegisterSecondCell
        let item = travel.dateList[indexPath.row]
        // Delegateを親VCに設定
        cell.cityNameTextField.delegate = self
        
        cell.dateLabel.text = item.date
        cell.cityNameTextField.text = item.cityName
        
        let targetCurrencyIndex = UserDefaults.registeredCurrencies.firstIndex(where: { $0.type == item.currency }) ?? 0
        
        ((cell.currencySelectionButton.menu?.children ?? [])[targetCurrencyIndex] as? UIAction)?.state = .on
        
        cell.cityNameTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                self.travel.dateList[indexPath.row].cityName = cell.cityNameTextField.text ?? ""
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }).disposed(by: cell.disposeBag)
        
        cell.selectedCurrencyRelay
            .subscribe(onNext: { [weak self] element in
                guard let self = self else {return}
                print("通貨が選択された index:\(indexPath.row), 値: \(element)")
                self.travel.dateList[indexPath.row].currency = element
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }).disposed(by: cell.disposeBag)
        
        return cell
    }
}

extension TravelRegisterSecondViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField.accept(textField)
        return true
    }
}
