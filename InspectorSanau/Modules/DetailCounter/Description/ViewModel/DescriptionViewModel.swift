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
    
    init(input: Input, realmService: RealmService, httpService: HTTPManager) {
        self.input = input
        self.output = DescriptionViewModel.output(input: input, description: description)
        
        self.httpService = httpService
        self.realmService = realmService
        
        description.accept([
            .init(leftTitle: "Серийный номер", rightTitle: "C7J1236"),
            .init(leftTitle: "Лицевой счет", rightTitle: "1234567"),
            .init(leftTitle: "Владелец", rightTitle: "Фамилия Имя Отчетство"),
            .init(leftTitle: "Адрес", rightTitle: "Город, Такой р-он,  мкр. Такой, ул. Такая, д.54, кв.8 "),
            .init(leftTitle: "Дата добавления", rightTitle: "18.12.2017"),
            .init(leftTitle: "Последняя активность", rightTitle: "18.03.2021, 15:12"),
            .init(leftTitle: "Вид", rightTitle: "Однофазный")
        ])
    }
}


// MARK: - Process

private extension DescriptionViewModel {
    
}

// MARK: - Output

private extension DescriptionViewModel {
    static func output(input: DescriptionViewModelPresentable.Input,
                       description: BehaviorRelay<[DescriptionWrapped]>) -> DescriptionViewModelPresentable.Output {
        return (description: description.asDriver(),
            ())
    }
}
