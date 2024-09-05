//
//  KeyboardOverlapUtil.swift
//  Tasuky
//
//  Created by 深瀬 貴将 on 2020/02/19.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

open class keyboardOverlapUtil {
    
    private static var lastTextFieldLimit: CGFloat = 0
    
    private static var buttonHeight: CGFloat = 52
    private static var bottomMargin: CGFloat = 20

    
    static func keyboardWillShowWithFloatingButton(notification: Notification, scrollView: UIScrollView, textField: UIView?, view: UIView, buttonConstraint: NSLayoutConstraint, extraMargin: CGFloat = 0, keepLoginButton: UIButton? = nil) {
        guard let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let mainBoundsSize = UIScreen.main.bounds.size
        let keyboardLimit = mainBoundsSize.height - rect.size.height
        let keyboardAndButtonLimit = mainBoundsSize.height - rect.size.height - buttonHeight - bottomMargin - extraMargin
        let currentScrollViewContentOffSetY = scrollView.contentOffset.y
        guard let textField: UIView = textField else { return }
        let textFieldFrame: CGRect = textField.convert(textField.frame, to: view)
        var textFieldLimit: CGFloat = textFieldFrame.origin.y + textFieldFrame.height + bottomMargin + 20//+20でバリデーションメッセージのエリアを確保
        
        //keepLoginButtonが存在するページだけチェック
        if let keepLoginButton = keepLoginButton {
            let keepLoginButtonFrame: CGRect = keepLoginButton.convert(keepLoginButton.frame, to: view)
            let keepLoginButtonLimit: CGFloat = keepLoginButtonFrame.origin.y + keepLoginButtonFrame.height
            
            //keepLoginButtonが隠れている場合だけkeepLoginButtonの高さ分移動距離を足す
            if (keepLoginButtonLimit - textFieldLimit) < keepLoginButtonFrame.height {
                textFieldLimit += keepLoginButtonFrame.height
            }
        }
        
        if keyboardAndButtonLimit <= textFieldLimit {
            let distanceToMove = textFieldLimit - keyboardAndButtonLimit
            scrollView.contentOffset.y = currentScrollViewContentOffSetY + distanceToMove
        }
        
        //ボタンの移動距離を計算
        let buttonBaseViewTargetHeight = mainBoundsSize.height - keyboardLimit + buttonHeight + (bottomMargin * 2) + extraMargin
        
        //ここでボタン制約を書き換え
        buttonConstraint.constant = buttonBaseViewTargetHeight
        //レイアウト更新
        view.layoutIfNeeded()
        
        //動かした時の値を保持しておく
        lastTextFieldLimit = textFieldLimit
    }
    
    static func keyboardWillHideWithFloatingButton(notification: Notification, scrollView: UIScrollView, view: UIView, buttonConstraint: NSLayoutConstraint, extraMargin: CGFloat = 0, buttonBaseViewInitialHeight: CGFloat = 126) {
        guard let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let mainBoundsSize = UIScreen.main.bounds.size
        let keyboardAndButtonLimit = mainBoundsSize.height - rect.size.height - buttonHeight - bottomMargin - extraMargin
        let currentScrollViewContentOffSetY = scrollView.contentOffset.y
        if keyboardAndButtonLimit <= lastTextFieldLimit {
            let distanceToMove = lastTextFieldLimit - keyboardAndButtonLimit
            scrollView.contentOffset.y = currentScrollViewContentOffSetY - distanceToMove
        }
        
        //ボタン制約を初期値に戻す
        buttonConstraint.constant = buttonBaseViewInitialHeight
        //レイアウト更新
        view.layoutIfNeeded()
    }
    

}
