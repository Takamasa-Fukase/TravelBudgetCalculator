//
//  RateSettingViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 6/9/24.
//

import UIKit
import RxSwift
import RxCocoa

class RateSettingViewController: UIViewController {
    let disposeBag = DisposeBag()
    var activeTextField = BehaviorRelay<UIView?>(value: nil)

    @IBOutlet weak var tableView: TouchesBeganTableView!
    @IBOutlet weak var toRegisterPageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "レート設定"
        
        setupTableView()
        setRxKeyboardMovement(disposeBag: disposeBag,
                              scrollView: tableView,
                              textField: activeTextField.asObservable(),
                              view: view,
                              buttonConstraint: NSLayoutConstraint())
        
        toRegisterPageButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                let vc = UIStoryboard(name: "CurrencyRegisterViewController", bundle: nil).instantiateInitialViewController() as! CurrencyRegisterViewController
                vc.delegate = self
                vc.modalPresentationStyle = .pageSheet
                self.present(vc, animated: true)
            }).disposed(by: disposeBag)
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "RateSettingCell", bundle: nil), forCellReuseIdentifier: "RateSettingCell")
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset.bottom = 200
    }
}

extension RateSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var editedData = UserDefaults.registeredCurrencies
        let selectedCurrency = editedData[indexPath.row]
        
        // 確認アラートを出す
        let alert = UIAlertController(title: "通貨を削除します", message: "本当によろしいですか？\n\n通貨：\(selectedCurrency.type.description)\nレート：\(selectedCurrency.toYenRate)円", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        let delete = UIAlertAction(title: "削除", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            // TODO: 旅行の記録に使用されている通貨は削除できないようにしたい（データが消えると困るので）
            
            editedData.remove(at: indexPath.row)
            UserDefaults.registeredCurrencies = editedData
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true)
    }
}

extension RateSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaults.registeredCurrencies.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RateSettingCell", for: indexPath) as! RateSettingCell
        let item = UserDefaults.registeredCurrencies[indexPath.row]
        // Delegateを親VCに設定
        cell.textField.delegate = self
        
        cell.currencyNameLabel.text = item.type.description
        cell.textField.text = "\(item.toYenRate)"
        
        cell.textField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                let doubleAmount = Double(cell.textField.text ?? "") ?? 0.0
                var editedData = UserDefaults.registeredCurrencies
                editedData[indexPath.row].toYenRate = doubleAmount
                UserDefaults.registeredCurrencies = editedData
                self.tableView.reloadData()
            }).disposed(by: cell.disposeBag)
        
        return cell
    }
}

extension RateSettingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField.accept(textField)
        return true
    }
}

extension RateSettingViewController: CurrencyRegisterDelegate {
    func onRegistered() {
        self.tableView.reloadData()
    }
}
