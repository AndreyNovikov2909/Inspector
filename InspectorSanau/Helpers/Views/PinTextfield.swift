//
//  PinTextfield.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//


import UIKit


protocol PinTextFieldDelegate: class {
    func pinTextFieldDelegateDidDeleteBackward(_ pinTextField: PinTextField)
}

enum PinTextFieldState {
    case hasText
    case empty
}

class PinTextField: UITextField {
    
    weak var myDelegate: PinTextFieldDelegate?
    
    override func deleteBackward() {
        myDelegate?.pinTextFieldDelegateDidDeleteBackward(self)
        super.deleteBackward()
    }
}

