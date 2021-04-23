//
//  TypeMetterViewController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/23/21.
//

import UIKit
import RxCocoa
import RxSwift

class TypeMetterViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ViewModel
    
    var builder: TypeMetterViewModelPresentable.Builder!
    private var viewModel: TypeMetterViewModelPresentable!
    
    // MARK: - Private propties
    
    private let selectedItem = PublishRelay<TypeMetterViewModel.TypeMetter>.init()
    
    // MARK: - Object livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationItem()
    }
}


// MARK: - Setup View Model

private extension TypeMetterViewController {
    func setupViewModel() {
        let input = (selectPhase: selectedItem.asDriver(onErrorDriveWith: .never()), ())
        viewModel = builder(input)
    }
}

// MARK: - SetupUI

private extension TypeMetterViewController {
    func setupUI() {
        view.backgroundColor = UIColor(named: "background")

        
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: TypeMetterTableViewCell.reuseID, bundle: nil),
                           forCellReuseIdentifier: TypeMetterTableViewCell.reuseID)
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
        navigationItem.title = "Вид счетчика"
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension TypeMetterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.output.phases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TypeMetterTableViewCell.reuseID, for: indexPath) as! TypeMetterTableViewCell
        let item = viewModel.output.phases[indexPath.row]
        cell.setup(withModel: item)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.output.phases[indexPath.row]
        selectedItem.accept(item)
        tableView.reloadData()
    }
}
