//
//  TypeMetterViewModel.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/23/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol TypeMetterViewModelPresentable {
    typealias Input = (selectPhase: Driver<TypeMetterViewModel.TypeMetter>, ())
    typealias Output = (phases: [TypeMetterViewModel.TypeMetter], ())
    typealias Builder = (Input) -> TypeMetterViewModelPresentable
    
    var input: Input { get set }
    var output: Output { get set }
}


final class TypeMetterViewModel: TypeMetterViewModelPresentable {
    
    
    var input: Input
    var output: Output
    
    enum TypeMetter: String, CaseIterable {
        case all, singlePhase, threePhase
        
        var title: String {
            switch self {
            case .all:
                return "Все"
            case .singlePhase:
                return "Однофазный"
            case .threePhase:
                return "Трехфазный"
            }
        }
    }
    
    private let dispose = DisposeBag()
    let defaults = DefaultsService.shared
    
    // MARK: - Init
    
    init(input: Input) {
        self.input = input
        self.output = TypeMetterViewModel.output(input: input)
        
        process()
    }
}

// MARK: - Process

private extension TypeMetterViewModel {
    func process() {
        input.selectPhase.asObservable().subscribe { [weak self] (event) in
            guard let self = self else { return }
            guard let element = event.element else { return }
            self.defaults.setPhase(element)
        }.disposed(by: dispose)
    }
}

// MARK: - Output

private extension TypeMetterViewModel {
    static func output(input: TypeMetterViewModelPresentable.Input) -> TypeMetterViewModelPresentable.Output {
        (phases: TypeMetterViewModel.TypeMetter.allCases, ())
    }
}
