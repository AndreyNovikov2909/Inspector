//
//  UIButton + extention.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/14/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay


extension UIButton {
    func makeLoginButton(withTitle title: String, textColor: UIColor?) {
        let attributedTitle = NSAttributedString(string: title,
                                                 attributes: [NSAttributedString.Key.foregroundColor: textColor ?? .white,
                                                              NSAttributedString.Key.font: UIFont(name: "Play", size: 19) ?? UIFont.systemFont(ofSize: 16, weight: .regular)])
        layer.cornerRadius = 25
        layer.masksToBounds = true
        setAttributedTitle(attributedTitle, for: .normal)
        backgroundColor = K.Colors.buttonColor1
    }
    
    func getAttributes(withTextColor textColor: UIColor?) -> NSAttributedString {
        return NSAttributedString(string: self.titleLabel?.text ?? "",
                                  attributes: [NSAttributedString.Key.foregroundColor: textColor ?? .white,
                                               NSAttributedString.Key.font: UIFont(name: "Play", size: 19) ?? UIFont.systemFont(ofSize: 16, weight: .regular)])
    }
}

extension UIButton {
    func buttonIsEnable(value: Bool) {
        let attributes = value ? getAttributes(withTextColor: .white)  : getAttributes(withTextColor: K.Colors.buttonTextColor1)
        isEnabled = value
        backgroundColor = isEnabled ? K.Colors.buttonColor : K.Colors.buttonColor1
        setAttributedTitle(attributes, for: .normal)
        setAttributedTitle(attributes, for: .selected)
    }
}
