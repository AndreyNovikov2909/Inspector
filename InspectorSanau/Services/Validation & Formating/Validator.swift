//
//  Validator.swift
//  Sanau
//
//  Created by Andrey Novikov on 2/15/21.
//

import Foundation

protocol ValidationProtocol {
    var maxNumberCount: Int { get set }
    
    func format(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String
    func getPhone(phoneNumber: String) -> String
    func validatePassword(password: String) -> Bool
    func passwordIsValid(password: String) -> Bool
    func nameIsvalid(name: String) -> Bool
    func isValidEmail(_ email: String) -> Bool
}

class Validation: ValidationProtocol {
    static let shared = Validation()
    var maxNumberCount = 11
   

    // 77081234567
    // +7 (708) 123-45-67
    func format(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
        guard !(shouldRemoveLastDigit && phoneNumber.count <= 2) else { return "+" }
        do {
        let regex = try NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        
        // add char after max number count
        if number.count > maxNumberCount {
            let maxIndex = number.index(number.startIndex, offsetBy: maxNumberCount)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        // when remove last symbol
        if shouldRemoveLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        // before 7 symbols
        if number.count < 7 {
            let pattern = "(\\d)(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
            // after 7 symbols
        } else {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        }
        
        return "+" + number
        } catch {
            return ""
        }
    }

    func getPhone(phoneNumber: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
            let range = NSString(string: phoneNumber).range(of: phoneNumber)
            return regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        } catch {
            return ""
        }
    }
    
    func validatePassword(password: String) -> Bool {
        return false
    }
    
    
    func usernameIsValid(username: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^([А-Я]{1}[а-яё]{1,30}|[A-Z]{1}[a-z]{3,30})$", options: [])
            let range = NSRange(location: 0, length: username.utf16.count)
            
            return  (regex.firstMatch(in: username, options: [], range: range) != nil)
        } catch {
            return false
        }
    }
    
    func passwordIsValid(password: String) -> Bool {
        return password.hasNumber && password.hasEightNumber && password.containtsUpperCase && password.latinCharactersOnly
    }
    
    func nameIsvalid(name: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^([А-Я]{1}[а-яё]{1,30}|[A-Z]{1}[a-z]{3,30})$", options: [])
            let range = NSRange(location: 0, length: name.utf16.count)
            
            return  (regex.firstMatch(in: name, options: [], range: range) != nil)
        } catch {
            return false
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
