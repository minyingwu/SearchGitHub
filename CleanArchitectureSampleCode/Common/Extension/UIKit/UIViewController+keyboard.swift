//
//  UIViewController+keyboard.swift
//  CleanArchitectureSampleCode
//
//  Created by Victor on 2021/3/14.
//

import UIKit

extension UIViewController {
    
    func setKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
}
