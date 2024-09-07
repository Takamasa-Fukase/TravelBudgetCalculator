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
        startDatePicker.timeZone = .current
        endDatePicker.timeZone = .current

        registerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
//                let startDate = startDatePicker.date
//                let endDate = endDatePicker.date
                let startDate = modifyTimeToZero(date: startDatePicker.date)
                let endDate = modifyTimeToZero(date: endDatePicker.date)
                
                let dates = generateDatesArray(from: startDate, to: endDate)
                let formatter = DateFormatter()
                formatter.dateFormat = "M月d日（E）" // 月日と曜日のフォーマット
                formatter.timeZone = TimeZone(abbreviation: "UTC")!
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
                
                // 画像ピッカーを実装したら実装する
//                guard let image = UIImage(named: "latin_america"),
//                      let imageData = image.pngData() else {
//                    print("Image converted to PNG Data successfully!")
//                    return
//                }
                
                let dateList = dateStrings.enumerated().map { (index, dateString) in
                    return DailyExpense(
                        date: dateString,
                        cityName: "\(index + 1)日目",
                        currency: .JPY,
                        expenseData: [
                            .init(paymentType: .transportation, items: [
                                .init(id: UUID(), title: "", amount: 0, currencyType: .JPY)
                            ]),
                            .init(paymentType: .food, items: [
                                .init(id: UUID(), title: "", amount: 0, currencyType: .JPY)
                            ]),
                            .init(paymentType: .other, items: [
                                .init(id: UUID(), title: "", amount: 0, currencyType: .JPY)
                            ])
                        ]
                    )
                }
                let travel = Travel(
                    name: travelNameTextField.text ?? "",
                    duration: "\(dateStrings.first ?? "")〜\(dateStrings.last ?? "")",
                    imageData: nil,
                    dateList: dateList
                )
                
                UserDefaults.travels = UserDefaults.travels + [travel]
                
                // 前の画面のリストを更新させるために通知
                self.delegate?.onRegistered()
                
                // 保存した内容を改めてアラートで表示
                self.showCompletionAlert(dateStrings: dateStrings, completion: {
                    self.dismiss(animated: true)
                })
                
            }).disposed(by: disposeBag)
    }
    
    func modifyTimeToZero(date: Date) -> Date {
        print("modifyTimeToZero: \(date)")
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = 23
        components.minute = 0
        components.second = 0
        let modifiedDate = calendar.date(from: components)
        print("modifiedDate: \(modifiedDate)")
        return modifiedDate ?? Date()
    }
    
    func generateDatesArray(from startDate: Date, to endDate: Date) -> [Date] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        print("generateDatesArray startDate: \(startDate), endDate: \(endDate)")
        var dates: [Date] = []
        print("dates: \(dates)")
        var currentDate = startDate
        print("currentDateにstartDateを代入した: \(currentDate)")
        
        while currentDate <= endDate {
            print("while currentDate <= endDateがtrueなので中に入った, currentDate(\(currentDate) <= endDate(\(endDate)")
            dates.append(currentDate)
            print("appendした後のdates: \(dates)")
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            print("+1の日で書き換えた後のcurrentDate: \(currentDate)")
        }
        
        print("whileを抜けたので返却するdates: \(dates)")
        
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
