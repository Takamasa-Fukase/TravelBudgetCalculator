//
//  TravelRegisterFirstViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 6/9/24.
//

import UIKit
import RxSwift
import RxCocoa

class TravelRegisterFirstViewController: UIViewController {
    let disposeBag = DisposeBag()
    weak var delegate: TravelRegisterDelegate?

    @IBOutlet weak var travelNameTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var toNextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "旅行を登録（1/2）"
        
        travelNameTextField.delegate = self
        travelNameTextField.returnKeyType = .done
        travelNameTextField.becomeFirstResponder()
        startDatePicker.timeZone = .current
        endDatePicker.timeZone = .current

        toNextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                let startDate = modifyTimeToZero(date: startDatePicker.date)
                let endDate = modifyTimeToZero(date: endDatePicker.date)
                
                let dates = generateDatesArray(from: startDate, to: endDate)
                let formatter = DateFormatter()
                formatter.dateFormat = "M月d日（E）" // 月日と曜日のフォーマット
                formatter.timeZone = .utc
                formatter.locale = Locale(identifier: "ja_JP") // 日本語のロケールを設定
                let dateStrings = dates.map { formatter.string(from: $0) }
                                
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
                
                // 通貨が未登録の場合は日本円を登録する
                if UserDefaults.registeredCurrencies.isEmpty {
                    UserDefaults.registeredCurrencies = [
                        RegisteredCurrency(type: .JPY, toYenRate: 1)
                    ]
                }
                guard let firstRegisteredCurrency = UserDefaults.registeredCurrencies.first else {
                    // 通貨が未登録の場合はありえない想定だがエラー表示
                    self.showError(title: "エラーが発生しました", message: "通貨が未登録です。\nTOPページ右上の「レート設定」から最低１つ登録を行なってください。")
                    return
                }
                
                let dateList = dateStrings.enumerated().map { (index, dateString) in
                    return DailyExpense(
                        date: dateString,
                        cityName: "\(index + 1)日目",
                        currency: .JPY,
                        expenseData: [
                            .init(paymentType: .transportation, items: [
                                .init(id: UUID(), title: "", amount: 0, currencyType: firstRegisteredCurrency.type)
                            ]),
                            .init(paymentType: .food, items: [
                                .init(id: UUID(), title: "", amount: 0, currencyType: firstRegisteredCurrency.type)
                            ]),
                            .init(paymentType: .other, items: [
                                .init(id: UUID(), title: "", amount: 0, currencyType: firstRegisteredCurrency.type)
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
                
                // 次画面に値を受け渡して遷移
                let vc = UIStoryboard(name: "TravelRegisterSecondViewController", bundle: nil).instantiateInitialViewController() as! TravelRegisterSecondViewController
                vc.travel = travel
                vc.delegate = self.delegate
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
    }
    
    func modifyTimeToZero(date: Date) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = .utc
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        let modifiedDate = calendar.date(from: components)
        return modifiedDate ?? Date()
    }
    
    func generateDatesArray(from startDate: Date, to endDate: Date) -> [Date] {
        var calendar = Calendar.current
        calendar.timeZone = .utc
        
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
}

extension TravelRegisterFirstViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
