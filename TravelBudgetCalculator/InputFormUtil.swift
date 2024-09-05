//
//  InputFormUtil.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 5/9/24.
//

import Foundation
import UIKit

class InputFormUtil {
    static func setupPickerView(_ pickerView: UIPickerView, delegate: UIPickerViewDelegate, dataSource: UIPickerViewDataSource) {
        pickerView.delegate = delegate
        pickerView.dataSource = dataSource
        pickerView.tintColor = .white
        pickerView.backgroundColor = .clear
    }
    
    static func setupDatePicker(_ datePicker: UIDatePicker) {
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = .current
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    static func setupToolBar(_ toolBar: UIToolbar, target: UIViewController?, action: Selector) {
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: action)
        toolBar.setItems([spacerItem, doneItem], animated: true)
    }
    
    
    static func setupNormalTextField(_ textField: UITextField, delegate: UITextFieldDelegate) {
        setupTextFieldCommonMethod(textField, delegate: delegate)
        textField.returnKeyType = .done
    }
    
    static func setupNumberTextField(_ textField: UITextField, delegate: UITextFieldDelegate, toolBar: UIToolbar) {
        setupTextFieldCommonMethod(textField, delegate: delegate)
        textField.keyboardType = .numberPad
        textField.inputAccessoryView = toolBar
    }
    
    static func setupEmailTextField(_ textField: UITextField, delegate: UITextFieldDelegate) {
        setupTextFieldCommonMethod(textField, delegate: delegate)
        textField.returnKeyType = .done
        textField.keyboardType = .emailAddress
    }
    
    static func setupPickerViewTextField(_ textField: UITextField, delegate: UITextFieldDelegate, pickerView: UIPickerView, toolBar: UIToolbar) {
        setupTextFieldCommonMethod(textField, delegate: delegate)
        textField.inputView = pickerView
        textField.inputView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textField.inputAccessoryView = toolBar
    }

    static func setupDatePickerTextField(_ textField: UITextField, delegate: UITextFieldDelegate, datePicker: UIDatePicker, toolBar: UIToolbar) {
        setupTextFieldCommonMethod(textField, delegate: delegate)
        textField.inputView = datePicker
        textField.inputView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textField.inputAccessoryView = toolBar
    }
    
    static func setupNormalTextView(_ textView: UITextView, delegate: UITextViewDelegate, toolBar: UIToolbar) {
        textView.delegate = delegate
        textView.inputAccessoryView = toolBar
        textView.inputView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 8, bottom: 15, right: 8)
    }
    
    //左側の余白部分にアイコンがあるなどでカスタムしたい時は、textFieldのセットアップメソッドの後に再度これを単体で呼び出して値を上書きする
    static func setupTextFieldLeftPadding(textField: UITextField, width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: textField.frame.size.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    //MARK: - Private Method
    //どの種類の場合も共通の設定をまとめたprivateメソッド
    private static func setupTextFieldCommonMethod(_ textField: UITextField, delegate: UITextFieldDelegate) {
        textField.delegate = delegate
    }
}
