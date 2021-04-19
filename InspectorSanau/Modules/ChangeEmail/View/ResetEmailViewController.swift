//
//  ResetEmailViewController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit
import RxViewController
import RxCocoa
import RxSwift

class ResetEmailViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    // MARK: - UI
    
    lazy var emailTextView: LoginTextView = {
        let textView = LoginTextView(title: "Введите ваш email", image: UIImage(named: "x-circle"))
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.makeLoginButton(withTitle: "ИЗМЕНИТЬ ПАРОЛЬ", textColor: K.Colors.buttonTextColor1)
        button.isEnabled = false
        return button
    }()

    // MARK: - ViewModel
    
    var builder: ResetEmailViewModelPresentable.Builder!
    private var viewModel: ResetEmailViewModelPresentable!
    
    
    // MARK: - Private properties
    
    private lazy var keyboardManager = KeyboardManager(viewController: self,
                                                       button: nextButton,
                                                       tabBarHeight: tabBarController?.tabBar.frame.height ?? 0)
    private let disposeBag = DisposeBag()
    
    // MARK: - Object livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        setupBinding()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)
        
        keyboardManager.addNotifications()
        setupNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        keyboardManager.removeNotifications()
        removeText()
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - Binding

private extension ResetEmailViewController {
    func setupViewModel() {
        let input = (email: emailTextView.messageTextField.rx.text.orEmpty.asDriver(),
                     clearButtonTap: emailTextView.messageTextField.rightButton.rx.tap.asDriver(),
                     acceptTap: nextButton.rx.tap.asDriver(),
                     didDisapear: rx.viewDidDisappear.map({ _ in return Void() }).asDriver(onErrorDriveWith: .never()))
        
        viewModel = builder(input)
    }
    
    func setupBinding() {
        // phone text field border color and bacground color
        
        viewModel.output.phoneTextFiledBackgroundColor.drive(emailTextView.messageTextField.rx.backgroundColor).disposed(by: disposeBag)
        
        viewModel.output.phoneTextFiledBorderColor.drive { [emailTextView] (borderColor)  in
            emailTextView.messageTextField.layer.borderColor = borderColor
            emailTextView.messageTextField.rightButton.tintColor = emailTextView.messageTextField.layer.borderColor == K.Colors.textFieldBorderColor1?.cgColor ? K.Colors.textFieldBorderColor2 : .white
            
            let tintColor = emailTextView.messageTextField.layer.borderColor == K.Colors.textFieldBorderColor1?.cgColor ? UIColor(named: "TextFieldRightImageEmptyTextColor") : UIColor(named: "TextFieldRightImageTextColor")
            emailTextView.messageTextField.rightButton.tintColor = tintColor

        }.disposed(by: disposeBag)


        // clear textFiled right button tap
        viewModel.output.clearButtonTap.drive { [weak self] _ in
            guard let self = self else { return }

            self.removeText()
            
        }.disposed(by: disposeBag)
        
        // button is enable
        viewModel.output.buttonIsEnable.drive { [nextButton] (value)  in
            nextButton.buttonIsEnable(value: value)
        }.disposed(by: disposeBag)
    }
}


// MARK: - Setup UI

private extension ResetEmailViewController {
    func setupUI() {
        setupPhoneTextView()
        setupTitleLabel()
        setupNextButton()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = K.Colors.navigationColor
        backView.backgroundColor = K.Colors.backViewColor
        backView.layer.cornerRadius = 30
    }
    
    func setupTitleLabel() {
        let attributedText = NSMutableAttributedString.getAttributedForregistrationTitle(title1: "Введите логин и пароль от ",
                                                                                         title2: "Sanau.SaaS")
        titleLabel.attributedText = attributedText
    }
    
    func setupPhoneTextView() {
        backView.addSubview(emailTextView)

        NSLayoutConstraint.activate([
            emailTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            emailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    func setupNextButton() {
        view.addSubview(nextButton)
        

        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.barTintColor = K.Colors.navigationColor
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "Смена пароля"
    }
    
    func removeText() {
        emailTextView.messageTextField.text = ""
        emailTextView.messageTextField.layer.borderColor = K.Colors.textFieldBorderColor1?.cgColor
        emailTextView.messageTextField.backgroundColor = K.Colors.textFieldBackColor1
        emailTextView.messageTextField.rightButton.tintColor = UIColor(named: "TextFieldRightImageEmptyTextColor")
        
        
        nextButton.buttonIsEnable(value: false)
    }

}
