//
//  HomeViewController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
        
    // MARK: - IBOutlets
    
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ViewModel
    
    var builder: HomeViewViewModelPresentable.Builder!
    private var viewModel: HomeViewViewModelPresentable!
    
    // MARK: - Private propties
    
    private let selectedItem = PublishRelay<HomeDetailWrapped>.init()
    private var presentbles: HomeWrapped?
    private let dispose = DisposeBag()
    
    // MARK: - Objetc livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupBinding()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationController()
    }
}


// MARK: - SetupViewModel

private extension HomeViewController {
    func setupViewModel() {
        let input = (selectedItem: selectedItem.asDriver(onErrorDriveWith: .never()), ())
        viewModel = builder(input)
    }
    
    func setupBinding() {
        viewModel.output.homeItems.asObservable().subscribe { [weak self] (event) in
            guard let self = self else { return }
            guard let values = event.element else { return }
            
            self.presentbles = values
            self.countLabel.text = "\(values.count)"
            self.tableView.reloadData()
        }.disposed(by: dispose)
    }
}

// MARK: - SetupUI

private extension HomeViewController {
    func setupUI() {
        setupLabel()
        setupTableView()
    }
    
    func setupTableView() {
        view.backgroundColor = UIColor(named: "background")
        
        switch viewModel.output.searchState {
        case .city, .district:
            tableView.rowHeight = 65
        case .done:
            tableView.rowHeight = 75
        }
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: HomeTableViewCell.reuseID, bundle: nil),
                           forCellReuseIdentifier: HomeTableViewCell.reuseID)
        tableView.register(UINib(nibName: HomeBluetoothTableViewCell.reuseID,
                                 bundle: nil), forCellReuseIdentifier: HomeBluetoothTableViewCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    func setupLabel() {
        availableLabel.text = "Всего устройств"

        availableLabel.textColor = UIColor(named: "TextColor1")
        countLabel.textColor = UIColor(named: "TextColor1")
    }
    
    func setupNavigationController() {

        
        switch viewModel.output.searchState {
        case .city:
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                            NSAttributedString.Key.font: UIFont(name: "Play", size: 26) ?? UIFont.systemFont(ofSize: 26, weight: .regular)]
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = K.Colors.navigationColor
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationItem.title = "Устройства"

        case .district, .done:
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                                  NSAttributedString.Key.font: UIFont(name: "Play", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .regular)]
            navigationController?.navigationBar.barTintColor = K.Colors.navigationColor
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.topItem?.title = ""
            navigationItem.largeTitleDisplayMode = .never
            navigationItem.title = "Поиск"
        }
    }
}


// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presentbles?.homeItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.output.searchState {
        case .city, .district:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseID, for: indexPath) as! HomeTableViewCell
            if let model =  presentbles?.homeItems[indexPath.row] {
                cell.setup(withMode: model)
            }
            return cell
        case .done:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeBluetoothTableViewCell.reuseID, for: indexPath) as! HomeBluetoothTableViewCell
            if let model =  presentbles?.homeItems[indexPath.row] {
                cell.setup(withModel: model)
            }
            return cell
        }
    }
}


// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = presentbles?.homeItems[indexPath.row] {
            selectedItem.accept(item)
        }
    }
}
