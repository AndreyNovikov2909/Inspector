//
//  DescriptionViewModel.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/20/21.
//

import Foundation
import RxSwift
import RxCocoa


protocol DescriptionViewModelPresentable {
    typealias Input = ()
    typealias Output = (description: Driver<[DescriptionWrapped]>, ())
    typealias Builder = (Input) -> DescriptionViewModelPresentable
    
    var input: Input { get set }
    var output: Output { get set }
}


final class DescriptionViewModel: DescriptionViewModelPresentable {
    
    var input: Input
    var output: Output
    
    // MARK: - Services
    
    private let realmService: RealmService
    private let httpService: HTTPService
    
    // MARK: - Private properrties
    
    private let description = BehaviorRelay<[DescriptionWrapped]>.init(value: [])
    private let dispose = DisposeBag()
    
    // MARK: - Init
    
    init(input: Input, realmService: RealmService, httpService: HTTPManager, id: String) {
        self.input = input
        self.output = DescriptionViewModel.output(input: input, description: description)
        
        self.httpService = httpService
        self.realmService = realmService
        
        userInfoRequest(serialNumber: id)
    }
}


// MARK: - Process

private extension DescriptionViewModel {
    func userInfoRequest(serialNumber: String) {
        let params = ["serialNumber": serialNumber]
        do {
            let result: Single<UserWrrapped> = try httpService.decodableRequest(request: ApplicationRouter.getBluetoothHumanData(params).asURLRequest())
            
            result.asObservable().subscribe { (event) in
                if let value = event.element {
                    self.description.accept([
                        .init(leftTitle: "Серийный номер", rightTitle: value.serialNumber ?? ""),
                        .init(leftTitle: "Лицевой счет", rightTitle: value.personalAccountNumber ?? ""),
                        .init(leftTitle: "Владелец", rightTitle: value.fullName ?? ""),
                        .init(leftTitle: "Адрес", rightTitle: value.location ?? ""),
                        .init(leftTitle: "Дата добавления", rightTitle: value.createdAt ?? ""),
                        .init(leftTitle: "Последняя активность", rightTitle: value.lastFixDate ?? ""),
                        .init(leftTitle: "Вид", rightTitle: value.type ?? "")
                    ])
                }
            }.disposed(by: dispose)
        }  catch {
            // error
        }
    }
}

// MARK: - Output

private extension DescriptionViewModel {
    static func output(input: DescriptionViewModelPresentable.Input,
                       description: BehaviorRelay<[DescriptionWrapped]>) -> DescriptionViewModelPresentable.Output {
        return (description: description.asDriver(),
            ())
    }
}
