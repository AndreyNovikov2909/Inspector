//
//  SMSStatus.swift
//  Sanau
//
//  Created by Andrey Novikov on 2/16/21.
//

import Foundation

enum SMSStatus {
    case changePassword(phone: String)
    case confirmNumber(phone: String)
    
    var title: String {
        switch self {
        case .changePassword:
            return "Смена пароля"
        case .confirmNumber:
            return "Подтвержение номера"
        }
    }
    
    var descriptionAttrubuted: NSAttributedString {
        switch self {
        case .changePassword(let phone):
           
            return NSMutableAttributedString.getAttributedForDescriptionLabel(title1: "На ваш номер ",
                                                                              title2: phone,
                                                                              title3: " отправлен код подтверждения смены пароля")
        case .confirmNumber(let phone):
            return NSMutableAttributedString.getAttributedForDescriptionLabel(title1: "На ваш номер ",
                                                                              title2: phone,
                                                                              title3: " отправлен код подтверждения")
        }
    }
}
