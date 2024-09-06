//
//  Extension+UIViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 5/9/24.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    func showError(title: String = "エラーが発生しました", message: String) {
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "閉じる", style: .default)
        errorAlert.addAction(ok)
        present(errorAlert, animated: true)
    }
    
    //キーボード開閉時のフローティングボタン＆textFieldのスクロール制御
    func setRxKeyboardMovement(disposeBag: DisposeBag, scrollView: UIScrollView, textField: Observable<UIView?>, view: UIView, buttonConstraint: NSLayoutConstraint, extraMargin: CGFloat = 0, keepLoginButton: UIButton? = nil, buttonBaseViewInitialHeight: CGFloat = 126) {
        
        //キーボード表示
        let _ = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification, object: nil)
            .withLatestFrom(textField) { (notifi, textField) in
                return (notifi, textField)
            }
            .subscribe(onNext: { [weak self] (notifi, textField) in
                guard self != nil else {return}
                //MARK: - 表示中の画面（textFieldがisFirstResponder中）だけのフィルター
                guard let textField = textField as? UITextField else { return }
                if !textField.isFirstResponder { return }
                keyboardOverlapUtil.keyboardWillShowWithFloatingButton(notification: notifi, scrollView: scrollView, textField: textField, view: view, buttonConstraint: buttonConstraint, extraMargin: extraMargin, keepLoginButton: keepLoginButton)
            }).disposed(by: disposeBag)
        
        //キーボード閉じる
        let _ = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification, object: nil)
            .withLatestFrom(textField) { (notifi, textField) in
                return (notifi, textField)
            }
            .subscribe(onNext: { [weak self] (notifi, textField) in
                guard self != nil else {return}
                //MARK: - 表示中の画面（textFieldがisFirstResponder中）だけのフィルター
                guard let textField = textField as? UITextField else { return }
                if !textField.isFirstResponder { return }
                keyboardOverlapUtil.keyboardWillHideWithFloatingButton(notification: notifi, scrollView: scrollView, view: view, buttonConstraint: buttonConstraint, extraMargin: extraMargin, buttonBaseViewInitialHeight: buttonBaseViewInitialHeight)
            }).disposed(by: disposeBag)
        
        //MEMO: - translucent=falseにしてもレイアウト及び座標計算上のview面積を以前のままに保つ為設定
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    // tableViewCellタップで遷移する画面のViewWillAppearで呼び出す（戻ってきた時にどのセルを見ていたかユーザーがわかりやすい様に）
    func dismissCellHighlight(tableView: UITableView) {
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            UIView.animate(withDuration: 0.2, animations: {
                tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
            })
        }
    }
}
