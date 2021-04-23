//
//  FilterViewController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/22/21.
//

import UIKit
import RxSwift
import RxCocoa

class FilterViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ViewModel
    
    var builder: FIlterViewModelPresentable.Builder!
    private var viewModel: FIlterViewModelPresentable!
    
    // MARK: - Private propties
    
    private let selectedItem = PublishRelay<FilterViewModel.FilterItem>.init()
    
    // MARK: - Object livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationItem()
    }
}


// MARK: - Setup ViewModels

private extension FilterViewController {
    func setupViewModel() {
        let input = (selectedItem: selectedItem.asDriver(onErrorDriveWith: .never()),())
        viewModel = builder(input)
    }
}

// MARK: - SetupUI

private extension FilterViewController {
    func setupUI() {
        view.backgroundColor = UIColor(named: "background")

        
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: FilterTableViewCell.reuseID, bundle: nil),
                           forCellReuseIdentifier: FilterTableViewCell.reuseID)
        tableView.contentInset.top = 16
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationItem() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                              NSAttributedString.Key.font: UIFont(name: "Play", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .regular)]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = K.Colors.navigationColor
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Фильтр"
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.output.filterItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.reuseID, for: indexPath) as! FilterTableViewCell
        let item = viewModel.output.filterItems[indexPath.row]
        cell.setup(withModel: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.output.filterItems[indexPath.row]
        selectedItem.accept(item)
    }
}
