//
//  NSAtributtedString + extention.swift
//  Sanau
//
//  Created by Andrey Novikov on 2/15/21.
//

import Foundation
import UIKit

extension NSAttributedString {
    static func getAttributedForregistrationTitle(title1: String, title2: String) -> NSMutableAttributedString {
        let mutableString = NSMutableAttributedString(string: title1,
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "MutableTitleColor") ?? UIColor.white,
                                                                   
                                                                   NSAttributedString.Key.font: UIFont(name: "Play", size: 16) ?? UIFont.systemFont(ofSize: 17, weight: .regular)])
        mutableString.append(NSAttributedString(string: title2, attributes: [NSAttributedString.Key.foregroundColor: K.Colors.textColor3 ?? .white,
                                                                                   NSAttributedString.Key.font: UIFont(name: "Play", size: 17) ?? UIFont.systemFont(ofSize: 16, weight: .regular)]))
        return mutableString
    }
    
    static func getAttributedForregistrationButton(title1: String, title2: String) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(string: title1,
                                                      attributes: [NSAttributedString.Key.foregroundColor: K.Colors.textColor ?? .white,
                                                                   NSAttributedString.Key.font: UIFont(name: "Play", size: 16) ?? UIFont.systemFont(ofSize: 15, weight: .regular)])
        mutableString.append(NSAttributedString(string: title2,
                                                attributes: [NSAttributedString.Key.foregroundColor: K.Colors.textColor2 ?? .white,
                                                             NSAttributedString.Key.font: UIFont(name: "Play", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)]))
        return mutableString
    }
}

extension NSMutableAttributedString {
    static func getAttributedForDescriptionLabel(title1: String, title2: String, title3: String) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(string: title1,
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "TextColor1.1") ?? .white,
                                                                   NSAttributedString.Key.font: UIFont(name: "Play", size: 16) ?? UIFont.systemFont(ofSize: 15, weight: .regular)])
        mutableString.append(NSAttributedString(string: title2,
                                                attributes: [NSAttributedString.Key.foregroundColor: K.Colors.textColor2 ?? .white,
                                                             NSAttributedString.Key.font: UIFont(name: "Play", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)]))
        
        mutableString.append(NSAttributedString(string: title3,
                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "TextColor1.1") ?? .white,
                                                             NSAttributedString.Key.font: UIFont(name: "Play", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)]))
        return mutableString
    }
    
    
    
    static func smsButtonStateOneButton(title1: String, title2: String) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(string: title1,
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "MutableTitleColor") ?? UIColor.white,
                                                                   NSAttributedString.Key.font: UIFont(name: "Play", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .regular)])
        mutableString.append(NSAttributedString(string: title2,
                                                attributes: [NSAttributedString.Key.foregroundColor: K.Colors.textColor2 ?? .white,
                                                             NSAttributedString.Key.font: UIFont(name: "Play", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .regular)]))
        return mutableString

    }
    
    static func smsButtonStateTwoButton(title1: String) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(string: title1,
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "MutableTitleColor") ?? UIColor.white,
                                                                   NSAttributedString.Key.font: UIFont(name: "Play", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .regular)])

        return mutableString
    }
}
