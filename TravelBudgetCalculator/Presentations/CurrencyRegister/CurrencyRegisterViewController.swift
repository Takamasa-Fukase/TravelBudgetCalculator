//
//  CurrencyRegisterViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 6/9/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol CurrencyRegisterDelegate: AnyObject {
    func onRegistered()
}

class CurrencyRegisterViewController: UIViewController {
    let disposeBag = DisposeBag()
    var selectedCurrency: CurrencyType?
    weak var delegate: CurrencyRegisterDelegate?

    @IBOutlet weak var currencySelectionButton: UIButton!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "通貨を登録"
        
        rateTextField.keyboardType = .numbersAndPunctuation
        rateTextField.returnKeyType = .done
        rateTextField.delegate = self
        setupCurrencySelectionButton()
        
        registerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                
                // 通貨が選択されていなかったらエラーを出す
                guard let selectedCurrency = selectedCurrency else {
                    self.showError(title: "通貨を選択してください", message: "")
                    return
                }
                
                // レートが未入力だったらエラーを出す
                guard let doubleAmount = Double(rateTextField.text ?? "") else {
                    self.showError(title: "レートの値が不正です", message: "")
                    return
                }
                
                // 同じ通貨だったらエラーを出す
                if UserDefaults.registeredCurrencies.contains(where: {
                    $0.type == selectedCurrency
                }) {
                    self.showError(title: "既に登録済みの通貨です", message: "異なる通貨を選択してください。既存の通貨を編集する場合は通貨一覧画面からレートの編集ができます。")
                    return
                }
                
                let newCurrency = RegisteredCurrency(type: selectedCurrency, toYenRate: doubleAmount)
                
                // UserDefaultsに保存
                UserDefaults.registeredCurrencies = UserDefaults.registeredCurrencies + [newCurrency]
                
                // 前の画面のリストを更新させるために通知
                self.delegate?.onRegistered()
                
                // 保存した内容を改めてアラートで表示
                self.showCompletionAlert(selectedCurrency: selectedCurrency, completion: {
                    self.dismiss(animated: true)
                })
            }).disposed(by: disposeBag)
    }
    
    func setupCurrencySelectionButton() {
        // 既に登録済みの通貨を除外した配列を作成
        var unregisteredCurrencies = CurrencyType.allCases.filter({ item in
            !UserDefaults.registeredCurrencies.contains(where: { $0.type == item })
        })
        
        // アルファベット順でソート
        unregisteredCurrencies.sort(by: { $0.code < $1.code })
        
        let currencyOptionList = unregisteredCurrencies.map { item in
            return UIAction(title: item.rawValue, handler: { [weak self] _ in
                guard let self = self else { return }
                // 選択された通貨を変数に保持
                self.selectedCurrency = item
            })
        }
        // 初期選択される通貨を変数に保持
        selectedCurrency = unregisteredCurrencies.first
        
        currencySelectionButton.menu = UIMenu(title: "通貨を選択", children: currencyOptionList)
        currencySelectionButton.showsMenuAsPrimaryAction = true
        currencySelectionButton.changesSelectionAsPrimaryAction = true
    }
    
    func showCompletionAlert(selectedCurrency: CurrencyType, completion: (@escaping () -> Void)) {
        let alert = UIAlertController(title: "通貨を登録しました", message: "通貨：\(selectedCurrency.description)\nレート：\(rateTextField.text ?? "")円", preferredStyle: .alert)
        let ok = UIAlertAction(title: "閉じる", style: .default, handler: { _ in
            completion()
        })
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

extension CurrencyRegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
