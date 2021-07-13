//
//  ChangePasswordViewModel.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/15/21.
//

import Foundation
import UIKit.UIColor
import RxSwift
import RxCocoa

protocol ChangePasswordViewModelPresentable {
    typealias Input = (viewDidDisappear: Driver<Void>,
                       firstPassword: Driver<String>,
                       secondPassword: Driver<String>,
                       firstSecureTap: Driver<Void>,
                       secondSecureTap: Driver<Void>,
                       changePasswordTap: Driver<Void>,
                       resetPasswordTap: Driver<Void>)
    
    typealias Output = (buttonIsEnable: Driver<Bool>,
                        firstPasswordTextFiledBackgroundColor: Driver<UIColor?>,
                        secondPasswordTextFeildBackgroundColor: Driver<UIColor?>,
                        firstPasswordTextFiledBorderColor: Driver<CGColor?>,
                        secondPasswordTextFiledBorderColor:  Driver<CGColor?>,
                        firstSecureTextTap: Driver<Void>,
                        secondSecureTextTap: Driver<Void>)
    
    typealias RouterAction = (changePasswordSuccess: PublishRelay<Void>,
                              changeEmaelTap: PublishRelay<Void>,
                              error: PublishRelay<Error>)
    
    typealias Routing = (dismissToSettings: Driver<Void>,
                         viewDidDisappear: Driver<Void>,
                         showChangeEmail: Driver<Void>,
                         showError: Driver<Error>)
    
    typealias Builder = (_ input: Input) -> ChangePasswordViewModelPresentable

    
    var input: Input { get set }
    var output: Output { get set }
}


// MARK: - LoginViewViewModel

final class ChangePasswordViewModel: ChangePasswordViewModelPresentable {
    
    // MARK: - Input & Output
    
    var input: Input
    var output: Output
    
    private let routerAction: RouterAction = (changePasswordSuccess: PublishRelay(),
                                              changeEmaelTap: PublishRelay(),
                                              error: PublishRelay<Error>())
    
    lazy var routing: Routing = (dismissToSettings: routerAction.changePasswordSuccess.asDriver(onErrorDriveWith: .empty()),
                                 viewDidDisappear: input.viewDidDisappear,
                                 showChangeEmail: routerAction.changeEmaelTap.asDriver(onErrorDriveWith: .empty()),
                                 showError: routerAction.error.asDriver(onErrorDriveWith: .empty()))
    
    
    // MARK: - Managers
    
    private let httpManager: HTTPManager
    private let validator: ValidationProtocol
    
    // MARK: - Private properties
        

    private let disposeBag = DisposeBag()

    // MARK: - Init
    
    required init(input: Input,
                  validator: ValidationProtocol = Validation(),
                  httpManager: HTTPManager) {
        self.input = input
        self.output = ChangePasswordViewModel.output(input: input,
                                                   validator: validator)
        
        self.validator = validator
        self.httpManager = httpManager

        
        changePasswordProcess()
        changeEmailProcess()
    }
}


// MARK: - Process

private extension ChangePasswordViewModel {
    func changePasswordProcess() {
        let passwordCombine = Driver.combineLatest(input.firstPassword, input.secondPassword)
        
        input.changePasswordTap.withLatestFrom(passwordCombine).asObservable().subscribe { (event) in
            guard let password = event.element else { return }

            self.changePassword(oldPassword: password.0, newPassword: password.1)
        }.disposed(by: disposeBag)
    }

    func changeEmailProcess() {
        input.resetPasswordTap.asObservable().subscribe { _ in
            self.routerAction.changeEmaelTap.accept(Void())

        }.disposed(by: disposeBag)
    }

    func changePassword(oldPassword: String, newPassword: String) {
        let params = ["oldPassword": oldPassword,
                      "newPassword": newPassword]

        guard let result: Single<AuthResponse> = try? httpManager.request(request: ApplicationRouter.putNewPassword(params: params).asURLRequest()) else {
            self.routerAction.error.accept(HTTPError.requestIsNil)
            return
        }

        result.asObservable().subscribe { [weak self] (event) in
            guard let self = self else { return }
            switch event {
            case .next(let element):
                if element.status == nil {
                    self.routerAction.changePasswordSuccess.accept(Void())
                } else {
                    let error = NSError(domain: element.message ?? "", code: element.status ?? -1, userInfo: [:])
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

private extension ChangePasswordViewModel {
    static func output(input: ChangePasswordViewModelPresentable.Input,
                       validator: ValidationProtocol) -> ChangePasswordViewModel.Output {
        
        let buttonIsEnable = Driver<Bool>.combineLatest(input.firstPassword, input.secondPassword) { (firstPassword, secondPassword) in
            print(firstPassword, secondPassword)
            return validator.passwordIsValid(password: firstPassword) && validator.passwordIsValid(password: secondPassword)
        }
        
        let firstPasswordTextFiledBackgroundColor = input.firstPassword
            .map({ $0.isEmpty })
            .map({ $0 == true ? K.Colors.textFieldBackColor1 : K.Colors.textFieldBackColor2 })
            .asDriver()
        
        let secondPasswordTextFeildBackgroundColor = input.secondPassword
            .map({ $0.isEmpty })
            .map({ $0 == true ? K.Colors.textFieldBackColor1 : K.Colors.textFieldBackColor2 })
            .asDriver()
        
        let firstPasswordTextFiledBorderColor = input.firstPassword
            .map({ $0.isEmpty })
            .map({ $0 == true ? K.Colors.textFieldBorderColor1?.cgColor : K.Colors.textFieldBorderColor2?.cgColor })
            .asDriver()
        
        let secondPasswordTextFiledBorderColor = input.secondPassword
            .map({ $0.isEmpty })
            .map({ $0 == true ? K.Colors.textFieldBorderColor1?.cgColor : K.Colors.textFieldBorderColor2?.cgColor })
            .asDriver()
        
        return (buttonIsEnable: buttonIsEnable,
                firstPasswordTextFiledBackgroundColor: firstPasswordTextFiledBackgroundColor,
                secondPasswordTextFeildBackgroundColor: secondPasswordTextFeildBackgroundColor,
                firstPasswordTextFiledBorderColor: firstPasswordTextFiledBorderColor,
                secondPasswordTextFiledBorderColor: secondPasswordTextFiledBorderColor,
                firstSecureTextTap: input.firstSecureTap,
                secondSecureTextTap: input.secondSecureTap)
    }
}
