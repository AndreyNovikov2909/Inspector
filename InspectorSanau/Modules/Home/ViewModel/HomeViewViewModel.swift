//
//  HomeViewViewModel.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/20/21.
//

import Foundation
import RxCocoa
import RxSwift

enum SearchState {
    case city
    case district(city: String)
    case done(city: String, district: String)
}

protocol HomeViewViewModelPresentable {
    typealias Input = (selectedItem: Driver<HomeDetailWrapped>, ())
    typealias Output = (homeItems: Driver<HomeWrapped>, searchState: SearchState)
    typealias RouterAction = (selectedItem: PublishRelay<HomeDetailWrapped>, ())
    typealias Routing = (showDetail: Driver<HomeDetailWrapped>, ())
    typealias Builder = (Input) -> HomeViewViewModelPresentable
    
    var input: Input { get set }
    var output: Output { get set }
}


final class HomeViewViewModel: HomeViewViewModelPresentable {
    
    // MARK: - Instance properties
    
    var input: Input
    var output: Output
    lazy var routing: Routing = (showDetail: routerAction.selectedItem.asDriver(onErrorDriveWith: .never()), ())
    
    // MARK: - Private properties
    
    private let routerAction: RouterAction = (selectedItem: PublishRelay<HomeDetailWrapped>(), ())
    private let dispose = DisposeBag()
    private let state: SearchState
    private let homeItems = BehaviorRelay<HomeWrapped>.init(value: .init(homeItems: []))
    
    // MARK: - Services
    
    private let httpService: HTTPService
    private let realmService: RealmService
    
    // MARK: - Init
    
    init(input: Input, httpService: HTTPService, realmService: RealmService, state: SearchState) {
        self.input = input
        self.output = HomeViewViewModel.output(input: input, homeItems: homeItems, searchState: state)
        self.state = state
        
        self.httpService = httpService
        self.realmService = realmService
        
        switch state {
        case .city:
            homeItems.accept(HomeWrapped.init(homeItems: [
                    .init(title: "Карагандинская область"),
                    .init(title: "Акмолинская область"),
                    .init(title: "Актюбинская область"),
                    .init(title: "Алматинская область"),
                    .init(title: "Жамбылская область")
            ]))
        case .district:
            homeItems.accept(
                HomeWrapped.init(homeItems: [
                .init(title: "Тараз"),
                .init(title: "Актобе"),
                .init(title: "Алматы"),
                .init(title: "Караганда"),
                .init(title: "Кокшетау")
            ]))
        case .done:
            let arr = [HomeDetailWrapped].init(repeating: .init(originalName: "CJ\(Int.random(in: 10000...99999))", ownerName: "Фамилия Имя Отчество"), count: Int.random(in: 1000...3000))
            homeItems.accept(HomeWrapped.init(homeItems: arr))
        }
        
        selectedProcess()
    }
}


// MARK: - Process

private extension HomeViewViewModel {
    func selectedProcess() {
        input.selectedItem.asObservable().subscribe { [weak self] (event) in
            guard let self = self else { return }
            guard  let item = event.element else { return }
            self.routerAction.selectedItem.accept(item)
        }.disposed(by: dispose)
    }
}


// MARK: - Output

private extension HomeViewViewModel {
    static func output(input: HomeViewViewModelPresentable.Input,
                       homeItems: BehaviorRelay<HomeWrapped>,
                       searchState: SearchState) -> HomeViewViewModelPresentable.Output {
        (homeItems: homeItems.asDriver(), searchState: searchState)
    }
}
