//
//  KeyboardService.swift
//  Sanau
//
//  Created by Andrey Novikov on 2/19/21.
//

import UIKit

class KeyboardService: NSObject {
    static var serviceSingleton = KeyboardService()
    var measuredSize: CGRect = CGRect.zero
    var animationTimeInterval: TimeInterval = 0
    var option: UIView.AnimationOptions = .curveEaseIn

    @objc class func keyboardHeight() -> CGFloat {
        let keyboardSize = KeyboardService.keyboardSize()
        return keyboardSize.size.height
    }

    @objc class func keyboardSize() -> CGRect {
        return serviceSingleton.measuredSize
    }

    private func observeKeyboardNotifications() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(self.keyboardChange), name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    private func observeKeyboard() {
        let field = UITextField()
        UIApplication.shared.windows.first?.addSubview(field)
        field.becomeFirstResponder()
        field.resignFirstResponder()
        field.removeFromSuperview()
    }

    @objc private func keyboardChange(_ notification: Notification) {
        guard measuredSize == CGRect.zero,
              animationTimeInterval == 0,
              let info = notification.userInfo,
              let timeInterval = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let value = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else { return }

        measuredSize = value.cgRectValue
        animationTimeInterval = timeInterval
        
        if let curveValue = (info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue {
            let curveAnimationOptions = UIView.AnimationOptions(rawValue: curveValue << 16)
           option = curveAnimationOptions
        }
    }

    override init() {
        super.init()
        observeKeyboardNotifications()
        observeKeyboard()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
