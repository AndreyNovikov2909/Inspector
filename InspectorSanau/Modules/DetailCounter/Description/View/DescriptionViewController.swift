//
//  DescriptionViewController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/19/21.
//

import UIKit
import RxSwift
import RxCocoa

class DescriptionViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ViewModel
    
    var builder: DescriptionViewModelPresentable.Builder!
    private var viewModel: DescriptionViewModelPresentable!
    
    // MARK: - Private propties
    
    private var elements: [DescriptionPresentable] = []
    private let dispose = DisposeBag()
    
    // MARK: - Object  livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupUI()
        setupViewModel()
        ssetupBinding()
    }
}


// MARK: - SetupViewModel

private extension DescriptionViewController {
    func setupViewModel() {
        let input = ()
        viewModel = builder(input)
    }
    
    func ssetupBinding() {
        viewModel.output.description.asObservable().subscribe { [weak self] (event) in
            guard let self = self else { return }
            guard let values = event.element else { return }
            self.elements = values
            self.tableView.reloadData()
        }.disposed(by: dispose)
    }
}


// MARK: - SetupUI

private extension DescriptionViewController {
    func setupUI() {
        view.backgroundColor = UIColor(named: "BackViewColor")
        
        setupTabaleView()
    }
    
    func setupTabaleView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: DescriptionTableViewCell.reuseID, bundle: nil),
                           forCellReuseIdentifier: DescriptionTableViewCell.reuseID)
    }
}


// MARK: - UITableViewDataSource

extension DescriptionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.reuseID,for: indexPath) as! DescriptionTableViewCell
        let value = elements[indexPath.row]
        cell.setup(withDescriptionPresentable: value)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DescriptionViewController: UITableViewDelegate {}
