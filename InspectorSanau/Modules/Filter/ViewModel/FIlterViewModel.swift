//
//  FIlterViewModel.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/22/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol FIlterViewModelPresentable {
    typealias Input = (selectedItem: Driver<FilterViewModel.FilterItem>, ())
    typealias Output = (filterItems: [FilterViewModel.FilterItem], ())
    typealias RouterAction = (didSelectedItem: PublishRelay<FilterViewModel.FilterItem>, ())
    typealias Routing = (showDescription: Driver<FilterViewModel.FilterItem>, ())
    typealias Builder = (Input) -> FIlterViewModelPresentable
    
    var input: Input { get set }
    var output: Output { get set }
}

final class FilterViewModel: FIlterViewModelPresentable {
    
    // MARK: - Instance properties
    
    var input: Input
    var output: Output
    lazy var routing: Routing = (showDescription: routingAction.didSelectedItem.asDriver(onErrorDriveWith: .empty()), ())
    
    // MARK: Nested properties
    
    enum FilterItem: Int, CaseIterable {
        case region, type
        
        var  title: String {
            switch self {
            case .region:
                return "Регион"
            case .type:
                return "Вид счетчика"
            }
        }
        
        var description: String {
            switch self {
            case .region:
                if (DefaultsService.shared.getCity() ?? "").isEmpty && (DefaultsService.shared.getDiscric() ?? "").isEmpty {
                    return ""
                } else {
                    return "\(DefaultsService.shared.getCity() ?? ""), \(DefaultsService.shared.getDiscric() ?? "")"
                }
            case .type:
                return "Все"
            }
        }
    }
    
    // MARK: - Private proprties
    
    private let routingAction = RouterAction(didSelectedItem: PublishRelay<FilterItem>(), ())
    private let dispose = DisposeBag()
    
    // MARK: - Init
    
    init(input: Input) {
        self.input = input
        self.output = FilterViewModel.output(input: input)
        
        routingProcesss()
    }
}

// MARK: - Process

private extension FilterViewModel {
    func routingProcesss() {
        input.selectedItem.asObservable().subscribe { (event) in
            guard let element = event.element else { return }
            self.routingAction.didSelectedItem.accept(element)
        }.disposed(by: dispose)
    }
}


// MARK: - Output

private extension FilterViewModel {
    static func output(input: FIlterViewModelPresentable.Input) -> FIlterViewModelPresentable.Output {
        (filterItems: FilterItem.allCases, ())
    }
}
