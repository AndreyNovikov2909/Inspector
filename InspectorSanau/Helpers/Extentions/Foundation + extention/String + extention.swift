//
//  String + extention.swift
//  Sanau
//
//  Created by Andrey Novikov on 2/19/21.
//

import UIKit
import SwiftRadix


extension String {
    var hasNumber: Bool {
        let numbers: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        for char in self {
            for number in numbers {
                if char == number {
                    return true
                }
            }
        }
        
        return false
    }
    
    var hasEightNumber: Bool {
        return self.count >= 8
    }
    
    var containtsUpperCase: Bool {
        let upperCase = CharacterSet.uppercaseLetters

        for currentCharacter in self.unicodeScalars {
            if upperCase.contains(currentCharacter) {
                return true
            }
        }
        
        return false
    }
}

extension String {
    var latinCharactersOnly: Bool {
        var text = self
        text.removeAll(where: { (String($0).range(of: "\\P{Latin}", options: .regularExpression) == nil) == false })
        
        return (text.range(of: "\\P{Latin}", options: .regularExpression) == nil) && text.count > 1
    }
}

extension String {
    func getWidth(font: UIFont? = UIFont(name: "Play", size: 13)) -> CGFloat {
        let label = UILabel()
        label.text = self
        label.numberOfLines = 1
        label.font = font
        return label.intrinsicContentSize.width
    }
}


extension String {
    static func convertToHexadecimal(byteArray: [UInt8]) -> String {
        var result = ""
        
        for byte in byteArray {
            let value = String(format:"%02X", byte)
            result.append(value)
        }
        
        return result
    }
    
    static func convertToHexadecimalArray(byteArray: [UInt8]) -> [UInt8] {
        var result = [UInt8]()
        
        for byte in byteArray {
            let value = String(format:"%02X", byte)
            let intValue = Int(value, radix: 16) ?? 0
            let int8Value = UInt8(intValue)

            result.append(int8Value)
        }
        
        return result
    }
    
    static func convert(byteArray: [UInt8]) -> String {
        var resString = ""
        var newArr = byteArray
        var result = [UInt8]()
        let const: UInt8 = 51
        
        if byteArray.count > 6 {
            newArr.removeLast()
            newArr.removeLast()
            
            let count = byteArray.count
            
            result.append(byteArray[count - 6])
            result.append(byteArray[count - 5])
            result.append(byteArray[count - 4])
            result.append(byteArray[count - 3])
        }
        
        let hexadecimalArray = result
       
        for b in hexadecimalArray.reversed() {
            let value =  b.hex - const.hex
            print("D:", value)
            /// last symbol
            if hexadecimalArray[0] == b {
                resString.append(".")
            }
            
            resString.append(value.stringValue)
            
            
        }
        
        for _ in hexadecimalArray {
            if resString.hasPrefix("0") || resString.hasPrefix(".")  {
                resString.removeFirst()
            }
        }

        return resString
    }
}

