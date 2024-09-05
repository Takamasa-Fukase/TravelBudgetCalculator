//
//  Extension+UIViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 5/9/24.
//

import UIKit

extension UIViewController {
    func showError(title: String = "エラーが発生しました", message: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "閉じる", style: .default)
        errorAlert.addAction(ok)
        present(errorAlert, animated: true)
    }
}
