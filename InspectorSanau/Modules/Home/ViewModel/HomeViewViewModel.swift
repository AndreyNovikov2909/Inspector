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
    typealias Input = (selectedItem: Driver<HomeDetailWrapped>,
                       showFilter: Driver<Void>,
                       searchText: Driver<String>,
                       searchTextRemoveText: Driver<Void>,
                       getNextBatch: Driver<Void>,
                       removeButton: Driver<Void>)
    typealias Output = (homeItems: Driver<HomeWrapped>,
                        searchState: SearchState,
                        removeAll: Driver<Void>)
    typealias RouterAction = (selectedItem: PublishRelay<HomeDetailWrapped>,
                              filterTap: PublishRelay<Void>,
                              error: PublishRelay<Error>)
    typealias Routing = (showDetail: Driver<HomeDetailWrapped>, showFilter: Driver<Void>, showError: Driver<Error>)
    typealias Builder = (Input) -> HomeViewViewModelPresentable
    
    var input: Input { get set }
    var output: Output { get set }
}


final class HomeViewViewModel: HomeViewViewModelPresentable {
    
    // MARK: - Instance properties
    
    var input: Input
    var output: Output
    lazy var routing: Routing = (showDetail: routerAction.selectedItem.asDriver(onErrorDriveWith: .never()),
                                 showFilter: routerAction.filterTap.asDriver(onErrorDriveWith: .never()),
                                 showError: routerAction.error.asDriver(onErrorDriveWith: .never()))
    
    // MARK: - Private properties
    
    private let routerAction: RouterAction = (selectedItem: PublishRelay<HomeDetailWrapped>(),
                                              filterTap: PublishRelay<Void>(),
                                              error: PublishRelay<Error>())
    private let dispose = DisposeBag()
    private let state: SearchState
    private let homeItems = BehaviorRelay<HomeWrapped>.init(value: .init(homeItems: []))
    private let removeAll = PublishRelay<Void>.init()
    
    // MARK: - Services
    
    private let httpService: HTTPManager
    private let realmService: RealmService
    
    private var currentBatch: Metterresponse?
    private var currrentFiltringBatch: Metterresponse?
    
    private var currentPage = 0
    private var currentFiltringPage = 0
    private var isFiltring = false
    
    // MARK: - Init
    
    init(input: Input, httpService: HTTPManager, realmService: RealmService, state: SearchState) {
        self.input = input
        self.output = HomeViewViewModel.output(input: input, homeItems: homeItems, searchState: state, removeAll: removeAll)
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

            getNextBatch(atPage: currentPage)
        }
        
        selectedProcess()
        showFilterProcess()
        getNextBatchProcess()
        searchTextProcess()
        DefaultsService.shared.setCurrentSate(state)
    }
}


// MARK: - Process

private extension HomeViewViewModel {
    
    func searchTextProcess() {
        input.searchText.debounce(DispatchTimeInterval.milliseconds(33)).asObservable().subscribe { (event) in
            guard let text = event.element else { return }
            self.currrentFiltringBatch = nil
            self.currentFiltringPage = 0
            
            self.currentPage = 0
            self.currentBatch = nil
            self.removeAll.accept(Void())
            
            if text.isEmpty && text.trimmingCharacters(in: .whitespaces).isEmpty {
                self.getNextBatch(atPage: 0)
                self.isFiltring = false
            } else {
                self.getNextbatchFilter(query: text, page: 0)
                self.isFiltring = true
            }
        }.disposed(by: dispose)
    }
    
    // filtring
    
    func getNextbatchFilter(query: String, page: Int) {
        let params: [String: Any] = ["query": query, "sortBy": "asc", "page": "\(page)", "size": "50"]
        do {
            let value: Single<Metterresponse> = try httpService.decodableRequest(request: ApplicationRouter.getMattersFromName(params).asURLRequest())
            value.subscribeOn(MainScheduler.instance).asObservable().subscribe { (event) in
                switch event {
                case .next(let result):
                    let homeDetalWrapped: [HomeDetailWrapped] = result.data.map { HomeDetailWrapped(originalName: $0.serialNumber, ownerName: $0.fullName) }
                    let homeWrapped = HomeWrapped(count: homeDetalWrapped.count, homeItems: homeDetalWrapped)
                    self.homeItems.accept(homeWrapped)
                    
                    self.currrentFiltringBatch = result
                    self.currentFiltringPage += 1
                    
                    self.currentPage = 0
                    self.currentBatch = nil
                    
                case .error(let error):
                    self.routerAction.error.accept(error)
                case .completed:
                    break
                }
            }.disposed(by: dispose)
        } catch {
            self.routerAction.error.accept(error)
        }
    }
    
    // get all
    
    func getNextBatchProcess() {
        input.getNextBatch.asObservable().subscribe { (event) in
            guard let _ = event.element else { return }
            self.nextBatch()
        }.disposed(by: dispose)
    }
    
    func nextBatch() {
        if isFiltring {
            if let currentBatch = currentBatch, currentPage < currentBatch.totalPage {
                getNextBatch(atPage: currentPage)
            } else {
                getNextBatch(atPage: 0)
            }
        } else {
            if let currrentFiltringBatch = currrentFiltringBatch, currentFiltringPage < currrentFiltringBatch.totalPage {
                getNextBatch(atPage: currentFiltringPage)
            } else {
                getNextBatch(atPage: 0)
            }
        }
    }
    
    func getNextBatch(atPage page: Int) {
        let params: [String: Any] = ["sortBy": "asc", "page": "\(page)", "size": "50"]

        do {
            let value: Single<Metterresponse> = try httpService.decodableRequest(request: ApplicationRouter.getAllMetters(params).asURLRequest())
            value.subscribeOn(MainScheduler.instance).asObservable().subscribe { (event) in
                switch event {
                case .next(let result):
                    let homeDetalWrapped: [HomeDetailWrapped] = result.data.map { HomeDetailWrapped(originalName: $0.serialNumber, ownerName: $0.fullName) }
                    let homeWrapped = HomeWrapped(count: homeDetalWrapped.count, homeItems: homeDetalWrapped)
                    self.homeItems.accept(homeWrapped)
                    self.currentBatch = result
                    self.currentPage += 1
                case .error(let error):
                    self.routerAction.error.accept(error)
                case .completed:
                    break
                }
            }.disposed(by: dispose)
        } catch {
            self.routerAction.error.accept(error)
        }
    }
    
    func selectedProcess() {
        input.selectedItem.asObservable().subscribe { [weak self] (event) in
            guard let self = self else { return }
            guard  let item = event.element else { return }
            self.routerAction.selectedItem.accept(item)
        }.disposed(by: dispose)
    }
    
    func showFilterProcess() {
        input.showFilter.asObservable().subscribe { [weak self] (event) in
            guard let self = self else { return }
            guard  let item = event.element else { return }
            self.routerAction.filterTap.accept(item)
        }.disposed(by: dispose)
    }
}


// MARK: - Output

private extension HomeViewViewModel {
    static func output(input: HomeViewViewModelPresentable.Input,
                       homeItems: BehaviorRelay<HomeWrapped>,
                       searchState: SearchState,
                       removeAll: PublishRelay<Void>) -> HomeViewViewModelPresentable.Output {
        (homeItems: homeItems.asDriver(),
         searchState: searchState,
         removeAll: removeAll.asDriver(onErrorDriveWith: .never()))
    }
}
