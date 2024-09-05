//
//  UIView+Extension.swift
//  AR-GunMan
//
//  Created by Takahiro Fukase on 2021/11/27.
//

import UIKit

extension UIView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
    }
}
