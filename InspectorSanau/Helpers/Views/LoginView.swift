//
//  LoginView.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//


import UIKit



class LoginTextView: UIView {

    // MARK: - UI
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont(name: "Play", size: 16)
        label.textColor = K.Colors.textColor
        return label
    }()
    
    var messageTextField: MessagesTextField!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String, image: UIImage?) {
        self.init(frame: .zero)
        
        backgroundColor = .clear
        
        titleLabel.text = title
        messageTextField = MessagesTextField(buttonImage: image)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, messageTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.backgroundColor = .clear
        stackView.spacing = -3
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        messageTextField.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        messageTextField.heightAnchor.constraint(equalToConstant: 47).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
