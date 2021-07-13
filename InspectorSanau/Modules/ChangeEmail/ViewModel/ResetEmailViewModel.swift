//
//  ResetEmailViewModel.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import Foundation
import UIKit.UIColor
import RxSwift
import RxCocoa
import RxRelay

protocol ResetEmailViewModelPresentable {
    typealias Input = (email: Driver<String>,
                       clearButtonTap: Driver<Void>,
                       acceptTap: Driver<Void>,
                       didDisapear: Driver<Void>)
    
    typealias Output = (buttonIsEnable: Driver<Bool>,
                        clearButtonTap: Driver<Void>,
                        phoneTextFiledBackgroundColor: Driver<UIColor?>,
                        phoneTextFiledBorderColor: Driver<CGColor?>)

    typealias Builder = (_ input: Input) -> ResetEmailViewModelPresentable
    typealias RoutingAction = (onRequest: PublishRelay<Result<Void, Error>>, ())
    typealias Routing = (dismissSelf: Driver<Void>, showAlert: Driver<Result<Void, Error>>)
    
    var input: Input { get set }
    var output: Output { get set }
}


// MARK: - ResetPasswordViewModel

final class ResetEmailViewModel: ResetEmailViewModelPresentable {
    
    var input: Input
    var output: Output

    // MARK: - Routing
    
    lazy var routing: Routing = (dismissSelf: input.didDisapear, showAlert: routingAction.onRequest.asDriver(onErrorDriveWith: .never()))
    private let routingAction: RoutingAction = (onRequest: PublishRelay<Result<Void, Error>>.init(), ())

    
    // MARK: - Private properties
    
    private let disposeBag = DisposeBag()
    
    private let validation: ValidationProtocol
    private let httpManager: HTTPManager
    
    // MARK: - Object live cycle
    
    required init(input: ResetEmailViewModel.Input,
                  validation: ValidationProtocol = Validation(),
                  httpManager: HTTPManager = HTTPManager()) {
        
        self.input = input
        self.output = ResetEmailViewModel.output(input: input, validation: validation)
        self.httpManager = httpManager
        self.validation = validation
        
        resetPasswordProccess()
    }
}

// MARK: - Process

extension ResetEmailViewModel {
    func resetPasswordProccess() {
        input.acceptTap.withLatestFrom(input.email).asObservable().subscribe { [weak self] (event) in
            guard let self = self else { return }
            guard let email = event.element else { return }
            self.resetPassword(email: email)
        }.disposed(by: disposeBag)
    }
    
    func resetPassword(email: String) {
        let params: [String: Any] = ["email": email]
        
        guard let result: Single<AuthResponse> = try? httpManager.request(request: ApplicationRouter.resetPassword(params: params).asURLRequest()) else {
            routingAction.onRequest.accept(.failure(HTTPError.requestIsNil))
            return
        }
        
        result.asObservable().subscribe { [weak self] (event) in
            guard let self = self else { return }
            switch event {
            case .next(let response):
                if response.status == nil { // let status = response.status, status == 200
                    self.routingAction.onRequest.accept(.success(Void()))
                } else {
                    let error = NSError(domain: "Unowned error", code: -1, userInfo: [:])
                    self.routingAction.onRequest.accept(.failure(error))
                }
            case .error(let error):
                self.routingAction.onRequest.accept(.failure(error))
            default: break
            }
            
        }.disposed(by: disposeBag)
    }
}


// MARK: - ResetPasswordViewModel

extension ResetEmailViewModel {
    static func output(input: ResetEmailViewModelPresentable.Input,
                       validation: ValidationProtocol) -> ResetEmailViewModelPresentable.Output {
        
        
        
        let buttonIsEnable = input.email
            .map({ validation.isValidEmail($0) })
            .asDriver()
        
        let clearButtonTap = input.clearButtonTap
            .asDriver()
        
        let phoneTextFieldBackgroundColor = input.email
            .map({ $0.isEmpty })
            .map({ $0 == true ? K.Colors.textFieldBackColor1 : K.Colors.textFieldBackColor2 })
            .asDriver()
        
        let phoneTextFiledBorderColor = input.email
            .map({ $0.isEmpty })
            .map({ $0 == true ? K.Colors.textFieldBorderColor1?.cgColor : K.Colors.textFieldBorderColor2?.cgColor })
            .asDriver()
        
        return (buttonIsEnable: buttonIsEnable,
                clearButtonTap: clearButtonTap,
                phoneTextFiledBackgroundColor: phoneTextFieldBackgroundColor,
                phoneTextFiledBorderColor: phoneTextFiledBorderColor)
    }
}
