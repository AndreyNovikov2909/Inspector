//
//  KeyboardManager.swift
//  Sanau
//
//  Created by Andrey Novikov on 2/18/21.
//

import UIKit

class KeyboardManager<T: UIViewController, B: UIButton>: NSObject {
    let viewController: T
    let button: B
    var bottomView: UIView?
    var buttonFrame: CGRect?
    let tabBarHeight: CGFloat
    
    init(viewController: T, button: B, buttomView: UIView? = nil, tabBarHeight: CGFloat = 0) {
        self.viewController = viewController
        self.button = button
        self.bottomView = buttomView
        self.tabBarHeight = tabBarHeight
        
        super.init()
    }
    
        
    @objc private func animateIn(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let timeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        guard let curveValue = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else { return }
        var animateOrigonY: CGFloat = 0
        
        if buttonFrame == nil {
            buttonFrame = button.frame
        }
        
        
        let option = UIView.AnimationOptions(rawValue: curveValue)
        let buttonYOrigin = viewController.view.frame.size.height - (buttonFrame?.origin.y ?? 0)
        let yTranslation = CGFloat(abs(keyboardSize.height - buttonYOrigin)) + button.frame.height + 10 - tabBarHeight
        
        if let bottomView = bottomView {
            let viewOrigin = viewController.view.frame.height - bottomView.frame.origin.y - bottomView.frame.height
        }
      
        UIView.animate(withDuration: timeInterval, delay: 0, options: option) {
            if self.tabBarHeight == 0 {
                self.button.transform = CGAffineTransform(translationX: 0, y: -yTranslation)
            } else {
                self.button.transform = CGAffineTransform(translationX: 0, y: -yTranslation + self.tabBarHeight - 50)
            }
        }
    }
    
    @objc private func animateOut(notification: Notification) {
        guard let timeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        guard let curveValue = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else { return }

        let option = UIView.AnimationOptions(rawValue: curveValue)


        UIView.animate(withDuration: timeInterval, delay: 0, options: option) {
            self.button.transform = .identity
        }
    }
    
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(animateIn), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateOut), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
