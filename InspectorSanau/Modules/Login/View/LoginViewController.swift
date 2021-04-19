//
//  LoginViewController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//


import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    // MARK: - UI
    
    lazy var emailTextView: LoginTextView = {
        let textView = LoginTextView(title: "Введите логин", image: UIImage(named: "x-circle"))
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var passwordTextView: LoginTextView = {
        let textView = LoginTextView(title: "Введите пароль", image: UIImage(named: "eye-slash"))
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.messageTextField.isSecureTextEntry = true
        return textView
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.makeLoginButton(withTitle: "ВОЙТИ", textColor: K.Colors.buttonTextColor1)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - ViewModel
    
    var builder: LoginViewViewModelPresentable.Builder!
    private var viewModel: LoginViewViewModelPresentable!

    // MARK: - Private properties
    
    private lazy var keyboardManager = KeyboardManager(viewController: self, button: loginButton)
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Object livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                        
        setupViewModel()
        binding()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboardManager.addNotifications()
        setupNavigationController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        keyboardManager.removeNotifications()
        removeText()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}



// MARK: - Binding

private extension LoginViewController {
    func setupViewModel() {
        let input = (email: emailTextView.messageTextField.rx.text.orEmpty.asDriver(),
                     password: passwordTextView.messageTextField.rx.text.orEmpty.asDriver(),
                     removeTextTap: emailTextView.messageTextField.rightButton.rx.tap.asDriver(),
                     secureTextTap: passwordTextView.messageTextField.rightButton.rx.tap.asDriver(),
                     loginTap: loginButton.rx.tap.asDriver(),
                     resetPasswordTap: resetPasswordButton.rx.tap.asDriver())
        
        viewModel = builder(input)
    }
    
    func binding() {
        // phone tf binding
        viewModel.output.phoneTextFiledBackgroundColor.drive(emailTextView.messageTextField.rx.backgroundColor).disposed(by: disposeBag)
        viewModel.output.phoneTextFiledBorderColor.drive { [emailTextView] (borderColor)  in
            emailTextView.messageTextField.layer.borderColor = borderColor
            emailTextView.messageTextField.rightButton.tintColor = emailTextView.messageTextField.layer.borderColor == K.Colors.textFieldBorderColor1?.cgColor ? UIColor(named: "TextFieldRightImageEmptyTextColor") : UIColor(named: "TextFieldRightImageTextColor")

        }.disposed(by: disposeBag)
        
        // password tf binding
        viewModel.output.passwordTextFeildBackgroundColor.drive(passwordTextView.messageTextField.rx.backgroundColor).disposed(by: disposeBag)
        viewModel.output.passwordTextFiledBorderColor.drive { [passwordTextView] (borderColor)  in
            passwordTextView.messageTextField.layer.borderColor = borderColor
            
            let tintColor = passwordTextView.messageTextField.layer.borderColor == K.Colors.textFieldBorderColor1?.cgColor ? UIColor(named: "TextFieldRightImageEmptyTextColor") : UIColor(named: "TextFieldRightImageTextColor")
            passwordTextView.messageTextField.rightButton.tintColor = tintColor
        }.disposed(by: disposeBag)
                
        
        // tf right action binding
        viewModel.output.removeTextTap.drive { [weak self] _ in
            guard let self = self else { return }
            let attributes = self.loginButton.getAttributes(withTextColor: K.Colors.buttonTextColor1)
            
            self.emailTextView.messageTextField.text?.removeAll()
            self.loginButton.backgroundColor = K.Colors.buttonColor1
            self.loginButton.setAttributedTitle(attributes, for: .normal)
            self.loginButton.setAttributedTitle(attributes, for: .selected)
            self.loginButton.isEnabled = false
            
        }.disposed(by: disposeBag)
        
        viewModel.output.secureTextTap.drive { [passwordTextView] _ in
            let image = passwordTextView.messageTextField.isSecureTextEntry ? UIImage(named: "eye") : UIImage(named: "eye-slash")
            passwordTextView.messageTextField.rightButton.setImage(image, for: .normal)
            passwordTextView.messageTextField.isSecureTextEntry.toggle()
            
        }.disposed(by: disposeBag)
        
        // button is enable
        viewModel.output.buttonIsEnable.drive { [loginButton] (value)  in
            loginButton.buttonIsEnable(value: value)
        }.disposed(by: disposeBag)
    }
}


// MARK: - Setup UI

private extension LoginViewController {
    func setupUI() {
        setupView()
        setupTitleLabel()
        setupTextViews()
        setupResetButton()
        setupLoginButton()
        setupNavigationController()
    }
    
    func removeText() {
        emailTextView.messageTextField.text = ""
        passwordTextView.messageTextField.text = ""
        
        emailTextView.messageTextField.layer.borderColor = K.Colors.textFieldBorderColor1?.cgColor
        emailTextView.messageTextField.backgroundColor = K.Colors.textFieldBackColor1
        emailTextView.messageTextField.rightButton.tintColor = UIColor(named: "TextFieldRightImageEmptyTextColor")
        
        passwordTextView.messageTextField.layer.borderColor = K.Colors.textFieldBorderColor1?.cgColor
        passwordTextView.messageTextField.backgroundColor = K.Colors.textFieldBackColor1
        passwordTextView.messageTextField.rightButton.tintColor = UIColor(named: "TextFieldRightImageEmptyTextColor")
        
        loginButton.buttonIsEnable(value: false)
        
        view.endEditing(true)
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
    
    
    func setupTextViews() {
        backView.addSubview(emailTextView)
        backView.addSubview(passwordTextView)
        
        NSLayoutConstraint.activate([
            emailTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            emailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            passwordTextView.topAnchor.constraint(equalTo: emailTextView.bottomAnchor, constant: 16),
            passwordTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    func setupResetButton() {
        let attributedTitle = NSAttributedString.getAttributedForregistrationButton(title1: "Забыли пароль? ", title2: "ВОССТАНОВИТЬ")
        
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        resetPasswordButton.setAttributedTitle(attributedTitle, for: .normal)
        resetPasswordButton.setAttributedTitle(attributedTitle, for: .selected)
        
        NSLayoutConstraint.activate([
            resetPasswordButton.topAnchor.constraint(equalTo: passwordTextView.bottomAnchor, constant: 10),
            resetPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupLoginButton() {
        view.addSubview(loginButton)
        

        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupNavigationController() {
        navigationItem.title = "Вход"
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = K.Colors.navigationColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                   NSAttributedString.Key.font: UIFont(name: "Play", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .regular)]
    }
}
