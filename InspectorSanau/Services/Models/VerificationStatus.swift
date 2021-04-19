//
//  VerificationStatus.swift
//  Sanau
//
//  Created by Andrey Novikov on 2/19/21.
//

import UIKit.UIColor

enum VerificationStatus: CaseIterable {
    case eightSymbol
    case oneUpperCase
    case oneNumber
    case latianSymbol
    
    var title: String {
        switch self {
        case .eightSymbol:
            return "8 символов"
        case .oneUpperCase:
            return "1 заглавная буква"
        case .oneNumber:
            return "1 цифра"
        case .latianSymbol:
            return "латинские буквы"
        }
    }
    
    var successBackground: UIColor? {
        return K.Colors.validationBackgroundS
    }
    
    var failureBackground: UIColor? {
        return  K.Colors.validationBackgroundF
    }
    
    var succesTextColor: UIColor? {
        return K.Colors.validationBackgroundSText
    }
    
    var failureTextColor: UIColor? {
        return K.Colors.validationBackgroundSTextF
    }
}
