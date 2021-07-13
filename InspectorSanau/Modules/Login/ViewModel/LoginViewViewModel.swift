//
//  LoginViewViewModel.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import Foundation
import UIKit.UIColor
import RxSwift
import RxCocoa

protocol LoginViewViewModelPresentable {
    typealias Input = (email: Driver<String>,
                       password: Driver<String>,
                       removeTextTap: Driver<Void>,
                       secureTextTap: Driver<Void>,
                       loginTap: Driver<Void>,
                       resetPasswordTap: Driver<Void>)
    
    typealias Output = (buttonIsEnable: Driver<Bool>,
                        phoneTextFiledBackgroundColor: Driver<UIColor?>,
                        passwordTextFeildBackgroundColor: Driver<UIColor?>,
                        phoneTextFiledBorderColor: Driver<CGColor?>,
                        passwordTextFiledBorderColor:  Driver<CGColor?>,
                        passwordErrorLabelIsHidden: Driver<Bool>,
                        removeTextTap: Driver<Void>,
                        secureTextTap: Driver<Void>)
    
    typealias Builder = (_ input: Input) -> LoginViewViewModelPresentable
    typealias RouterAction = (loginSuccess: PublishRelay<Void>, changeEmaelTap: PublishRelay<Void>, error: PublishRelay<Error>)
    typealias Routing = (showMain: Driver<Void>, showChangeEmail: Driver<Void>, showError: Driver<Error>)
    
    var input: Input { get set }
    var output: Output { get set }
}


// MARK: - LoginViewViewModel

final class LoginViewViewModel: LoginViewViewModelPresentable {
    
    // MARK: - Input & Output
    
    var input: Input
    var output: Output
    
    private let routerAction: RouterAction = (loginSuccess: PublishRelay(),
                                              changeEmaelTap: PublishRelay(),
                                              error: PublishRelay<Error>())
    
    lazy var routing: Routing = (showMain: routerAction.loginSuccess.asDriver(onErrorDriveWith: .empty()),
                                 showChangeEmail: routerAction.changeEmaelTap.asDriver(onErrorDriveWith: .empty()),
                                 showError: routerAction.error.asDriver(onErrorDriveWith: .empty()))
    
    
    // MARK: PropertyWarpped
    
    @DefaultsObservable<String>(key: DefaultsService.access_token_key) var accessToken
    @DefaultsObservable<String>(key: DefaultsService.refresh_token_key) var refreshObservable
    
    // MARK: - Private properties
        
    private let httpManager = HTTPManager()
    private let disposeBag = DisposeBag()
    private let validator: ValidationProtocol
    
    // MARK: - Init
    
    required init(input: LoginViewViewModelPresentable.Input,
                  validator: ValidationProtocol = Validation(),
                  httpManager: HTTPManager = HTTPManager()) {
        self.input = input
        self.output = LoginViewViewModel.output(input: input,
                                                   validator: validator)
        
        self.validator = validator
        DefaultsService.shared.setFirstLaunch(value: false)
        
        loginProcess()
        changeEmailProcess()
    }
    
    func loginProcess() {
        let login = Driver<Login>.combineLatest(input.email, input.password) { Login(name: $0, password: $1) }
        input.loginTap.withLatestFrom(login).asObservable().subscribe { (event) in
            guard let login = event.element else { return }
            
            self.auth(name: login.name, password: login.password)
                
        }.disposed(by: disposeBag)
    }
    
    func changeEmailProcess() {
        input.resetPasswordTap.asObservable().subscribe { _ in
            self.routerAction.changeEmaelTap.accept(Void())
            
        }.disposed(by: disposeBag)
    }
    
    func auth(name: String, password: String) {
        let params = ["login": name,
                      "password": password]
        
        guard let result: Single<AuthResponse> = try? httpManager.request(request: ApplicationRouter.login(param: params).asURLRequest()) else {
            self.routerAction.error.accept(HTTPError.requestIsNil)
            return
        }
       
        result.asObservable().subscribe { [weak self] (event) in
            guard let self = self else { return }
            switch event {
            case .next(let element):
                if let accessToken = element.accessToken, let refreshToken = element.refreshToken {
                    
                    DefaultsService.shared.setAuth(value: true)
                    self.accessToken = accessToken
                    self.refreshObservable = refreshToken
                    self.routerAction.loginSuccess.accept(Void())
                    
                    
                } else {
                    let error = ErrorDescription(description: element.message ?? "")
                    self.routerAction.error.accept(error)
                }
            case .error(let error):
                self.routerAction.error.accept(error)
            default: break
            }
        }.disposed(by: disposeBag)
    }
}


// MARK: - Output

private extension LoginViewViewModel {
    static func output(input: LoginViewViewModelPresentable.Input,
                       validator: ValidationProtocol) -> LoginViewViewModelPresentable.Output {
        
        let buttonIsEnable = Driver<Bool>.combineLatest(input.email, input.password) { (email, password) in
            return (email.count > 2) && validator.passwordIsValid(password: password)
        }
        
        let phoneTextFieldBackgroundColor = input.email
            .map({ $0.isEmpty })
            .map({ $0 == true ? K.Colors.textFieldBackColor1 : K.Colors.textFieldBackColor2 })
            .asDriver()
        
        let passwordTextFeildBackgroundColor = input.password
            .map({ $0.isEmpty })
            .map({ $0 == true ? K.Colors.textFieldBackColor1 : K.Colors.textFieldBackColor2 })
            .asDriver()
        
        let phoneTextFiledBorderColor = input.email
            .map({ $0.isEmpty })
            .map({ $0 == true ? K.Colors.textFieldBorderColor1?.cgColor : K.Colors.textFieldBorderColor2?.cgColor })
            .asDriver()
        
        let passwordTextFiledBorderColor = input.password
            .map({ $0.isEmpty })
            .map({ $0 == true ? K.Colors.textFieldBorderColor1?.cgColor : K.Colors.textFieldBorderColor2?.cgColor })
            .asDriver()
        
        let passwordErrorLabelIsHidden = input.password
            .map({ !validator.validatePassword(password: $0) })
            .asDriver()

        
        return (buttonIsEnable: buttonIsEnable,
                phoneTextFiledBackgroundColor: phoneTextFieldBackgroundColor,
                passwordTextFeildBackgroundColor: passwordTextFeildBackgroundColor,
                phoneTextFiledBorderColor: phoneTextFiledBorderColor,
                passwordTextFiledBorderColor: passwordTextFiledBorderColor,
                passwordErrorLabelIsHidden: passwordErrorLabelIsHidden,
                removeTextTap: input.removeTextTap,
                secureTextTap: input.secureTextTap)
    }
}
