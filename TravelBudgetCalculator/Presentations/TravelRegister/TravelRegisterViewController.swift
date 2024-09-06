//
//  TravelRegisterViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 6/9/24.
//

import UIKit
import RxSwift
import RxCocoa

class TravelRegisterViewController: UIViewController {
    let disposeBag = DisposeBag()

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
}

extension TravelRegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
