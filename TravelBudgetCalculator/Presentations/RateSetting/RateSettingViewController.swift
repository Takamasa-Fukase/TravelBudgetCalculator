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
//    var registeredCurrencies: [RegisteredCurrency] = [
//        .init(type: .USD, toYenRate: 0),
//        .init(type: .ARA, toYenRate: 0),
//        .init(type: .COP, toYenRate: 0),
//        .init(type: .MXN, toYenRate: 0),
//        .init(type: .JPY, toYenRate: 0)
//    ]

    @IBOutlet weak var tableView: TouchesBeganTableView!
    @IBOutlet weak var toRegisterPageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
//                self.registeredCurrencies[indexPath.row].toYenRate = doubleAmount
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
