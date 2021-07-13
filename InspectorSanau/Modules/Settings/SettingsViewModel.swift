//
//  SettingsViewModel.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/15/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol SettingsViewModelPresentable {
    typealias Input = (selectedType: Driver<SettingsViewModel.SettingsType>, logout: Driver<Void>, viewDidload: Driver<Void>)
    typealias Output = (settings: [SettingsViewModel.SettingsType], user: Driver<UserPresentable>)
    typealias Builder = (Input) -> SettingsViewModelPresentable
    typealias RouterAction = (changePassword: PublishRelay<Void>, ())
    typealias Routing = (showAuth: Driver<Void>, showChangePassword: Driver <Void>)
    
    var input: Input { get set }
    var output: Output { get set }
}


final class SettingsViewModel: SettingsViewModelPresentable {
    
    // MARK: - Public protpies
    
    var input: Input
    var output: Output
    
    // MARK: - Routing
    
    private let routingAction: RouterAction = (changePassword: PublishRelay<Void>() ,())
    lazy var routing: Routing = (showAuth: input.logout, showChangePassword: routingAction.changePassword.asDriver(onErrorDriveWith: .empty()))
    
    // MARK: - Nested types
    
    enum SettingsType: Int, CaseIterable {
        case changePassword
        
        var title: String {
            switch self {
            case .changePassword: return "Изменить пароль"
            }
        }
    }
    
    // MARK: - Managers
    
    private let httpManager: HTTPService
    private let realmService: Realmable
    
    // MARK: - Private properties
    
    private let user = PublishRelay<UserPresentable>()
    private let dispose = DisposeBag()
    
    
    // MARK: - Object livecycle
    
    init(input: Input, httpManager: HTTPManager, realmService: RealmService) {
        self.input = input
        self.realmService = realmService
        self.httpManager = httpManager
        self.output = SettingsViewModel.output(input: input,
                                               user: user)
        
        requestUser()
        selectedItem()
       getProcess()
    }
}

// MARK: - Proccess

private extension SettingsViewModel {
    
    func getProcess() {
        input.viewDidload.asObservable().subscribe { (_) in
//            self.getUser()
        }.disposed(by: dispose)
    }
    
    func requestUser() {
        do {
            let single: Single<UserWrapped> = try httpManager.decodableRequest(request: ApplicationRouter.getOperatorProfile(params: [:]).asURLRequest())
            
            single.asObservable().subscribe { event in
                switch event {
                
                case .next(let response):
                    self.saveUser(response)
                case .error(_):
                    break
                case .completed:
                    break
                }
                
            }.disposed(by: dispose)
        } catch {
        }
    }
    
    func saveUser(_ userWrapped: UserWrapped) {
        guard userWrapped.email != nil else { return }
        
        DefaultsService.shared.setUser(userWrapped)
        
//        let userObject = User()
//
//        userObject.fullName = userWrapped.fullName
//        userObject.email = userWrapped.email
//        userObject.phoneNumber = userWrapped.phoneNumber
//        userObject.roleName = userWrapped.roleName
//
//        try? realmService.saveObject(value: userObject)
        self.user.accept(userWrapped)
    }
    
    func getUser() {
        if let savedUser: User = realmService.getObjects().last {
            let userWrapped = UserWrapped(fullName: savedUser.fullName,
                                          email: savedUser.email,
                                          phoneNumber: savedUser.phoneNumber,
                                          roleName: savedUser.roleName)
            
            user.accept(userWrapped)
        }
    }
    
    func selectedItem() {
        input.selectedType
            .asObservable()
            .map { (type) in
                if type == .changePassword {
                    self.routingAction.changePassword.accept(Void())
                }
            }.subscribe()
            .disposed(by: dispose)
    }
}


// MARK: - Output

private extension SettingsViewModel {
    static func output(input: SettingsViewModelPresentable.Input,
                       user: PublishRelay<UserPresentable>) -> SettingsViewModelPresentable.Output {
        
        return (settings: SettingsViewModel.SettingsType.allCases,
                user: user.asDriver(onErrorDriveWith: .empty()))
    }
}
