//
//  FavoriteViewController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit
import RxSwift
import RxCocoa

class SearchDeviceViewController: UIViewController {
 
    // MARK: - ViewModel
     
    var builder: SearchDeviceViewModelPresentable.Builder!
    private var viewModel: SearchDeviceViewModelPresentable!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var availableItemsLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    // MARK: - Private proprties
    
    private let selectedEtem = PublishRelay<BluetoothWapped>.init()
    private var bluetoothElements = [BluetoothWapped]()
    private let dispose = DisposeBag()

    
    // MARK: - Object livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewModel()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
}


// MARK: - Setup View Model

private extension SearchDeviceViewController {
    func setupViewModel() {
        let input = (selectedCounter: selectedEtem.asDriver(onErrorDriveWith: .never()), ())
        viewModel = builder(input)
    }
    
    func setupBinding() {
        viewModel.output.bluetoothWapped.asObservable().subscribe { [weak self] (event) in
            guard let values = event.element else { return }
            self?.update(withBluetoothWrapped: values)
        }.disposed(by: dispose)
    }
}

// MARK: - Setup UI

private extension SearchDeviceViewController {
    func setupUI() {
        setupTableView()
        setupLabel()
    }
    
    func setupTableView() {
        view.backgroundColor = UIColor(named: "background")
        
        tableView.rowHeight = 65
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: BluetoothTableViewCell.reuseID, bundle: nil),
                           forCellReuseIdentifier: BluetoothTableViewCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupLabel() {
        availableItemsLabel.text = "Доступные устройства"
        counterLabel.text = "0"
        
        availableItemsLabel.textColor = UIColor(named: "TextColor1")
        counterLabel.textColor = UIColor(named: "TextColor1")
    }
    
    func update(withBluetoothWrapped bluetoothWrapped: [BluetoothWapped]) {
        bluetoothElements = bluetoothWrapped
        counterLabel.text = "\(bluetoothWrapped.count)"
        tableView.reloadData()
    }
    
    func setupNavigationController() {
        navigationItem.title = "Поиск устройств"
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = K.Colors.navigationColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                   NSAttributedString.Key.font: UIFont(name: "Play", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .regular)]
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension SearchDeviceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bluetoothElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BluetoothTableViewCell.reuseID, for: indexPath) as! BluetoothTableViewCell
        let element = bluetoothElements[indexPath.row]
        cell.setup(withModel: element)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = bluetoothElements[indexPath.row]
        selectedEtem.accept(item)
    }
}
