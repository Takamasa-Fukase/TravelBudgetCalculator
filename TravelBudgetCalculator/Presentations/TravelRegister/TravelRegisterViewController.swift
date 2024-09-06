//
//  TravelRegisterViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 6/9/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol TravelRegisterDelegate: AnyObject {
    func onRegistered()
}

class TravelRegisterViewController: UIViewController {
    let disposeBag = DisposeBag()
    weak var delegate: TravelRegisterDelegate?

    @IBOutlet weak var travelNameTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        travelNameTextField.delegate = self

        registerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                let startDate = startDatePicker.date
                let endDate = endDatePicker.date
                
                let dates = generateDatesArray(from: startDate, to: endDate)
                let formatter = DateFormatter()
                formatter.dateFormat = "M月d日（E）" // 月日と曜日のフォーマット
                formatter.locale = Locale(identifier: "ja_JP") // 日本語のロケールを設定
                
                let dateStrings = dates.map { formatter.string(from: $0) }
                
                print("dateStrings: \(dateStrings)")
                
                if (travelNameTextField.text ?? "").isEmpty {
                    self.showError(title: "タイトルを入力してください", message: "")
                    return
                }
                
                if dateStrings.isEmpty {
                    self.showError(title: "日付が不正です", message: "")
                    return
                }
                
                // UserDefaultsに保存
//                UserDefaults.registeredCurrencies = UserDefaults.registeredCurrencies + [newCurrency]
                
                // 前の画面のリストを更新させるために通知
                self.delegate?.onRegistered()
                
                // 保存した内容を改めてアラートで表示
                self.showCompletionAlert(dateStrings: dateStrings, completion: {
                    self.dismiss(animated: true)
                })
                
            }).disposed(by: disposeBag)
    }
    
    func generateDatesArray(from startDate: Date, to endDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    func showCompletionAlert(dateStrings: [String], completion: (@escaping () -> Void)) {
        let alert = UIAlertController(title: "旅行を登録しました", message: "タイトル：\(travelNameTextField.text ?? "")\n期間：\(dateStrings.first ?? "")〜\(dateStrings.last ?? "")", preferredStyle: .alert)
        let ok = UIAlertAction(title: "閉じる", style: .default, handler: { _ in
            completion()
        })
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

extension TravelRegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
