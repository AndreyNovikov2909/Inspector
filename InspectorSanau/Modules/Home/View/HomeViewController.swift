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
    @IBOutlet weak var searchBackView: UIView!
    
    // MARK: - UI
    
    private lazy var searchTextField: MessagesTextField = {
        let textField = MessagesTextField(buttonImage: UIImage(named: ""))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 0.7
        textField.layer.borderColor = UIColor(named: "TitleTextColor")?.cgColor
        textField.rightButton.tintColor = .white
        textField.delegate = self
        textField.placeholder = "Фамилия, Имя, серийный номер, лицевой счет"
        textField.defaultTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor(named: "TextFieldTextColor") ?? .white,
                                            NSAttributedString.Key.font: UIFont(name: "Play", size: 18) ?? .systemFont(ofSize: 18)]
        return textField
    }()
    
    
    // MARK: - ViewModel
    
    var builder: HomeViewViewModelPresentable.Builder!
    private var viewModel: HomeViewViewModelPresentable!
    
    // MARK: - Private propties
    
    private let selectedItem = PublishRelay<HomeDetailWrapped>.init()
    private let showFilter = PublishRelay<Void>.init()
    private var presentbles: HomeWrapped = .init(count: 0, homeItems: [])
    private var getNextItems = PublishRelay<Void>()
    private var searchText = PublishRelay<String>()
    private let dispose = DisposeBag()
    
    // MARK: - Objetc livecycle
    
    var httpManager = HTTPManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupBinding()
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationController()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleSearchText),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.25 {
            getNextItems.accept(Void())
        }
    }
    
    // MARK: - Selecctor methods
    
    @objc private func handleFilterTapped() {
        showFilter.accept(Void())
    }
    
    @objc private func handleSearchText(notification: Notification) {
        guard let text = searchTextField.text else { return }
        searchText.accept(text)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
}


// MARK: - SetupViewModel

private extension HomeViewController {
    func setupViewModel() {
        let input = (selectedItem: selectedItem.asDriver(onErrorDriveWith: .never()),
                     showFilter: showFilter.asDriver(onErrorDriveWith: .never()),
                     searchText: searchText.asDriver(onErrorDriveWith: .never()),
                     searchTextRemoveText: searchTextField.rightButton.rx.tap.asDriver(),
                     getNextBatch: getNextItems.asDriver(onErrorDriveWith: .never()),
                     removeButton: searchTextField.rightButton.rx.tap.asDriver())
        viewModel = builder(input)
    }
    
    func setupBinding() {
        viewModel.output.homeItems.asObservable().subscribe { [weak self] (event) in
            guard let self = self else { return }
            guard let values = event.element else { return }
            
            self.presentbles.homeItems.append(contentsOf: values.homeItems)
            self.presentbles.homeItems = self.presentbles.homeItems.uniqued()
            self.countLabel.text = "\(self.presentbles.homeItems.count)"
            self.tableView.reloadData()
        }.disposed(by: dispose)
        
        
        viewModel.output.removeAll.asObservable().subscribe { [weak self] (event) in
            guard let self = self else { return }
            guard let _ = event.element else { return }
            
            self.presentbles.homeItems.removeAll()
            self.countLabel.text = "0"
            self.tableView.reloadData()
        }.disposed(by: dispose)
    }
}

// MARK: - SetupUI

private extension HomeViewController {
    func setupUI() {
        setupLabel()
        setupTableView()
        setupSearchBackView()
        textField()
    }
    
    func setupTableView() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
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
    
    func setupSearchBackView() {
        searchBackView.backgroundColor = K.Colors.navigationColor
    }
    
    func textField() {
        view.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            searchTextField.centerYAnchor.constraint(equalTo: searchBackView.centerYAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: searchBackView.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: searchBackView.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                   NSAttributedString.Key.font: UIFont(name: "Play", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .regular)]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = K.Colors.navigationColor
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.largeTitleDisplayMode = .never
        
        switch viewModel.output.searchState {
        case .city:
            navigationItem.title = "Устройства"
        case .district, .done:
            navigationItem.title = "Поиск"
            
        }
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleFilterTapped))
    }
}


// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presentbles.homeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.output.searchState {
        case .city, .district:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseID, for: indexPath) as! HomeTableViewCell
            let model =  presentbles.homeItems[indexPath.row]
            cell.setup(withMode: model)
            cell.meDelegate = self
            return cell
        case .done:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeBluetoothTableViewCell.reuseID, for: indexPath) as! HomeBluetoothTableViewCell
                let model =  presentbles.homeItems[indexPath.row]
                cell.setup(withModel: model)
            cell.myDelegate = self
            return cell
        }
    }
}


// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = presentbles.homeItems[indexPath.row]
        selectedItem.accept(item)
    }
}


// MARK: - UITextFieldDelegate

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - HomeTableViewCellDelegate

extension HomeViewController: HomeTableViewCellDelegate {
    func homeTableViewCellDidTap(_ homeTableViewCell: HomeTableViewCell) {
        guard let indexPath = tableView.indexPath(for: homeTableViewCell) else { return }
         let item = presentbles.homeItems[indexPath.row]
        selectedItem.accept(item)
    }
}


// MARK: - HomeBluetoothTableViewCellDegate

extension HomeViewController: HomeBluetoothTableViewCellDegate {
    func homeBluetoothTableViewCellDidSelect(_ homeBluetoothTableViewCell: HomeBluetoothTableViewCell) {
        guard let indexPath = tableView.indexPath(for: homeBluetoothTableViewCell) else { return }
        let item = presentbles.homeItems[indexPath.row]
        selectedItem.accept(item)
    }
}


extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
