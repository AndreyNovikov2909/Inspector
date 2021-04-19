//
//  ChangePasswordViewController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/15/21.
//

import UIKit
import RxCocoa
import RxSwift

class ChangePasswordViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    // MARK: - UI
    
    lazy var firstPasswordTextView: LoginTextView = {
        let textView = LoginTextView(title: "Текущий пароль", image: UIImage(named: "eye-slash"))
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.messageTextField.isSecureTextEntry = true
        return textView
    }()
    
    lazy var secondPasswordTextView: LoginTextView = {
        let textView = LoginTextView(title: "Введите новый пароль", image: UIImage(named: "eye-slash"))
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.messageTextField.isSecureTextEntry = true
        return textView
    }()
    
    lazy var changePassswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.makeLoginButton(withTitle: "Изменить пароль", textColor: K.Colors.buttonTextColor1)
        button.isEnabled = false
        return button
    }()
    
    private lazy var collectionView: VerificationCollectionView = {
        let collectionView = VerificationCollectionView(frame: .zero)
        return collectionView
    }()

    
    // MARK: - ViewModel
    
    var builder: ChangePasswordViewModelPresentable.Builder!
    private var viewModel: ChangePasswordViewModelPresentable!

    // MARK: - Private properties
    
    private lazy var keyboardManager = KeyboardManager(viewController: self,
                                                       button: changePassswordButton,
                                                       tabBarHeight: tabBarController?.tabBar.frame.height ?? 0)
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
        collectionView.remove()
        removeText()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Selector methods
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
}



// MARK: - Binding

private extension ChangePasswordViewController {
    func setupViewModel() {
        let input = (viewDidDisappear: rx.viewDidDisappear.map({ _ in }).asDriver(onErrorDriveWith: .never()),
                    firstPassword: firstPasswordTextView.messageTextField.rx.text.orEmpty.asDriver(),
                     secondPassword: secondPasswordTextView.messageTextField.rx.text.orEmpty.asDriver(),
                     firstSecureTap: firstPasswordTextView.messageTextField.rightButton.rx.tap.asDriver(),
                     secondSecureTap: secondPasswordTextView.messageTextField.rightButton.rx.tap.asDriver(),
                     changePasswordTap: changePassswordButton.rx.tap.asDriver(),
                     resetPasswordTap: forgotPasswordButton.rx.tap.asDriver())
        
        viewModel = builder(input)
    }
    
    func binding() {
        // phone tf binding
        viewModel.output.firstPasswordTextFiledBackgroundColor.drive(firstPasswordTextView.messageTextField.rx.backgroundColor).disposed(by: disposeBag)
        viewModel.output.firstPasswordTextFiledBorderColor.drive { [firstPasswordTextView] (borderColor)  in
            firstPasswordTextView.messageTextField.layer.borderColor = borderColor
            firstPasswordTextView.messageTextField.rightButton.tintColor = firstPasswordTextView.messageTextField.layer.borderColor == K.Colors.textFieldBorderColor1?.cgColor ? UIColor(named: "TextFieldRightImageEmptyTextColor") : UIColor(named: "TextFieldRightImageTextColor")

        }.disposed(by: disposeBag)
        
        // password tf binding
        viewModel.output.secondPasswordTextFeildBackgroundColor.drive(secondPasswordTextView.messageTextField.rx.backgroundColor).disposed(by: disposeBag)
        viewModel.output.secondPasswordTextFiledBorderColor.drive { [secondPasswordTextView] (borderColor)  in
            secondPasswordTextView.messageTextField.layer.borderColor = borderColor
            
            let tintColor = secondPasswordTextView.messageTextField.layer.borderColor == K.Colors.textFieldBorderColor1?.cgColor ? UIColor(named: "TextFieldRightImageEmptyTextColor") : UIColor(named: "TextFieldRightImageTextColor")
            secondPasswordTextView.messageTextField.rightButton.tintColor = tintColor
        }.disposed(by: disposeBag)
                
        
        // tf right action binding
        viewModel.output.firstSecureTextTap.drive { [firstPasswordTextView] _ in
            let image = firstPasswordTextView.messageTextField.isSecureTextEntry ? UIImage(named: "eye") : UIImage(named: "eye-slash")
            firstPasswordTextView.messageTextField.rightButton.setImage(image, for: .normal)
            firstPasswordTextView.messageTextField.isSecureTextEntry.toggle()
            
        }.disposed(by: disposeBag)
        
        viewModel.output.secondSecureTextTap.drive { [secondPasswordTextView] _ in
            let image = secondPasswordTextView.messageTextField.isSecureTextEntry ? UIImage(named: "eye") : UIImage(named: "eye-slash")
            secondPasswordTextView.messageTextField.rightButton.setImage(image, for: .normal)
            secondPasswordTextView.messageTextField.isSecureTextEntry.toggle()
            
        }.disposed(by: disposeBag)
        
        // button is enable
        viewModel.output.buttonIsEnable.drive { [changePassswordButton] (value)  in
            changePassswordButton.buttonIsEnable(value: value)
        }.disposed(by: disposeBag)
    }
}


// MARK: - Setup UI

private extension ChangePasswordViewController {
    func setupUI() {
        setupView()
        setupTextViews()
        setupLoginButton()
        setupNavigationController()
        setupForgotPasswordButton()
        setupCollectionView()
    }
    
    func removeText() {
        firstPasswordTextView.messageTextField.rx.text.onNext("")
        secondPasswordTextView.messageTextField.rx.text.onNext("")        
        
        firstPasswordTextView.messageTextField.becomeFirstResponder()
        firstPasswordTextView.messageTextField.resignFirstResponder()

        secondPasswordTextView.messageTextField.becomeFirstResponder()
        secondPasswordTextView.messageTextField.resignFirstResponder()
        
        firstPasswordTextView.messageTextField.layer.borderColor = K.Colors.textFieldBorderColor1?.cgColor
        firstPasswordTextView.messageTextField.backgroundColor = K.Colors.textFieldBackColor1
        firstPasswordTextView.messageTextField.rightButton.tintColor = UIColor(named: "TextFieldRightImageEmptyTextColor")
        
        secondPasswordTextView.messageTextField.layer.borderColor = K.Colors.textFieldBorderColor1?.cgColor
        secondPasswordTextView.messageTextField.backgroundColor = K.Colors.textFieldBackColor1
        secondPasswordTextView.messageTextField.rightButton.tintColor = UIColor(named: "TextFieldRightImageEmptyTextColor")
        
        changePassswordButton.buttonIsEnable(value: false)
        
        view.endEditing(true)
    }
    
    func setupView() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        view.backgroundColor = K.Colors.navigationColor
        backView.backgroundColor = K.Colors.backViewColor
        backView.layer.cornerRadius = 30
    }
    
    func setupTextViews() {
        backView.addSubview(firstPasswordTextView)
        backView.addSubview(secondPasswordTextView)
        
        NSLayoutConstraint.activate([
            firstPasswordTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            firstPasswordTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            firstPasswordTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            secondPasswordTextView.topAnchor.constraint(equalTo: firstPasswordTextView.bottomAnchor, constant: 16),
            secondPasswordTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            secondPasswordTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    func setupLoginButton() {
        view.addSubview(changePassswordButton)
        

        NSLayoutConstraint.activate([
            changePassswordButton.bottomAnchor.constraint(equalTo: forgotPasswordButton.topAnchor, constant: -16),
            changePassswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            changePassswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            changePassswordButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.barTintColor = K.Colors.navigationColor
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "Смена пароля"
    }
    
    func setupForgotPasswordButton() {
        forgotPasswordButton.backgroundColor = K.Colors.backViewColor
        forgotPasswordButton.setTitleColor(UIColor(named: "TextColor3"), for: .normal)
        forgotPasswordButton.setTitle("Забыли пароль?", for: .normal)
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        
        secondPasswordTextView.messageTextField.rx.text.orEmpty.asDriver().drive(collectionView.password).disposed(by: disposeBag)
                
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: secondPasswordTextView.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

}

