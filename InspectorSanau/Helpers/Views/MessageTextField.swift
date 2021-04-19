//
//  MessageTextField.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//


import UIKit
import RxSwift
import RxCocoa

protocol MessagesTextFieldDelegate: class {
    func messagesTextField(_ messagesTextField: MessagesTextField, rightButtonTapped: UIButton)
}

class MessagesTextField: UITextField {
            
    // MARK: - UI
    
    @IBInspectable var rightButton = UIButton(type: .system)
    let tileLabel = UILabel()
    
    // MARK: - Live cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupTextField()

    }
    
    convenience init(buttonImage: UIImage? = nil) {
        self.init(frame: .zero)
        
        setupTextField()
        if let buttonImage = buttonImage {
            setupRightButton(image: buttonImage)
        }
    }
        
    
    // MARK: - Set position for text field subviews
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 12
        return rect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 24, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 24, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 24, dy: 0)
    }
    
    override func borderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 24, dy: 0)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 30, dy: 0)
    }
    
    
    // MARK: - Setup
    
    private func setupTextField() {
        
        defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "TextFieldTextColor") ?? .white,
                                 NSAttributedString.Key.font: UIFont(name: "Play", size: 23) ?? .systemFont(ofSize: 23)]
        textAlignment = .left
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        borderStyle = .none
        layer.masksToBounds = true
        backgroundColor = K.Colors.textFieldBackColor1
        layer.borderWidth = 1.5
        layer.borderColor = K.Colors.textFieldBorderColor1?.cgColor
        layer.cornerRadius = 20
    }
    
    
    func setupRightButton(image: UIImage?) {
        let timplateImage = image?.withRenderingMode(.alwaysTemplate)
        rightButton.imageView?.contentMode = .scaleAspectFit
        rightButton.setImage(timplateImage, for: .normal)
        rightButton.tintColor = K.Colors.textFieldBorderColor2
        rightView = rightButton
        rightViewMode = .always
        
        addSubview(rightButton)
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rightButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightButton.heightAnchor.constraint(equalToConstant: 18),
            rightButton.widthAnchor.constraint(equalToConstant: 18)
        ])
    }
}

