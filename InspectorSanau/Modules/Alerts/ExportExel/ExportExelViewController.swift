//
//  ExportExelViewController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 5/12/21.
//

import UIKit


class ExportExelViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameBackView: UIView!
    
    @IBOutlet weak var leftTextField: MessagesTextField!
    @IBOutlet weak var rigthTextField: MessagesTextField!
    @IBOutlet weak var viewBetweenTextField: UIView!
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var deviderView: UIView!
    @IBOutlet weak var spaceView: UIView!
    
    
    lazy var emailTextView: LoginTextView = {
        let textView = LoginTextView(title: "Наименование документа:", image: UIImage(named: ""))
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.messageTextField.placeholder = "Наименование"
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        leftTextField.delegate = self
        rigthTextField.delegate = self
        
        
        leftTextField.defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "TextFieldTextColor") ?? .white,
                                 NSAttributedString.Key.font: UIFont(name: "Play", size: 16) ?? .systemFont(ofSize: 16)]
        
        rigthTextField.defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "TextFieldTextColor") ?? .white,
                                                NSAttributedString.Key.font: UIFont(name: "Play", size: 16) ?? .systemFont(ofSize: 16)]
        
        spaceView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc func handleTap() {
        dismiss(animated: true, completion: nil)
    }
}


extension ExportExelViewController {
    func setupUI() {
        setupTextViews()
        
        backView.layer.cornerRadius = 30
        backView.backgroundColor = UIColor(named: "ExelBlackground")
        titleLabel.textColor = UIColor(named: "TitleColor")
        
        leftImageView.changeColor(color: UIColor(named: "ExelGray"))
        rightImageView.changeColor(color: UIColor(named: "ExelGray"))
        
        setupTf(leftTextField)
        setupTf(rigthTextField)
        setupTf(emailTextView.messageTextField)
        
        acceptButton.makeLoginButton(withTitle: "ЗАГРУЗИТЬ", textColor: K.Colors.buttonTextColor1)
        acceptButton.buttonIsEnable(value: false)
    }
    
    func setupTf(_ tf: UITextField) {
        tf.backgroundColor = UIColor(named: "ExelTextFieldBackground")
        tf.textColor = UIColor(named: "TitleColor")
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(named: "ExelGray")?.cgColor
    }
    
    func setupTextViews() {
        backView.addSubview(emailTextView)
        
        NSLayoutConstraint.activate([
            emailTextView.bottomAnchor.constraint(equalTo: nameBackView.bottomAnchor, constant: 0),
            emailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}


extension ExportExelViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Format Date of Birth dd/MM/yyyy

        //initially identify your textfield


            // check the chars length dd -->2 at the same time calculate the dd-MM --> 5
        if (textField.text?.count == 2) || (textField.text?.count == 5) {
                //Handle backspace being pressed
                if !(string == "") {
                    // append the text
                    textField.text = (textField.text)! + "/"
                }
            }
            // check the condition not exceed 9 chars
            return !(textField.text!.count > 9 && (string.count ) > range.length)
    }
}
