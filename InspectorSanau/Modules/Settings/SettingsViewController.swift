//
//  SettingsViewController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: - ViewModels
    
    var builder: SettingsViewModelPresentable.Builder!
    private var viewModel: SettingsViewModelPresentable!
    
    // MARK: - Private properties
    
    private let selectedType = PublishRelay<SettingsViewModel.SettingsType>()
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



// MARK: - ViewModels

private extension SettingsViewController {
    func setupViewModel() {
        let input = (selectedType: selectedType.asDriver(onErrorDriveWith: .empty()),
                     logout: logoutButton.rx.tap.asDriver())
        viewModel = builder(input)
    }
    
    func setupBinding() {
        viewModel.output.user.asObservable().subscribe { [weak self] (event) in
            guard let self = self else { return }
            if let element = event.element {
                self.fullNameLabel.text = "\(element.middleName) \(element.firstName) \(element.lastName)"
                self.professionLabel.text = "Оператор"
                self.phoneNumberLabel.text = element.phoneNumber
                self.emailLabel.text = element.email
            }
        }.disposed(by: dispose)
    }
}

// MARK: - Setup UI

private extension SettingsViewController {
    func setupUI() {
        setupTableView()
        setupHeaderView()
    }
    
    func setupHeaderView() {
        backgroundView.backgroundColor = UIColor(named: "avatarBackground")
        
        avatarImageView.backgroundColor = .clear
        avatarImageView.image = UIImage(named: "person-circle")
        avatarImageView.changeColor(color: UIColor(named: "avatarImageView"))
        
        backgroundView.layer.cornerRadius = backgroundView.frame.height / 2
        mainView.backgroundColor = UIColor(named: "viewBackground")
        logoutButton.backgroundColor = UIColor(named: "viewBackground")
        logoutButton.setTitleColor(UIColor(named: "mainTitle"), for: .normal)
        logoutButton.setTitle("Выйти", for: .normal)
        view.backgroundColor = UIColor(named: "background")
        
        fullNameLabel.textColor = UIColor(named: "mainTitle")
        professionLabel.textColor = UIColor(named: "descriptionTitles")
        phoneNumberLabel.textColor = UIColor(named: "descriptionTitles")
        emailLabel.textColor = UIColor(named: "descriptionTitles")
        
//        fullNameLabel.text = ""
//        professionLabel.text = ""
//        phoneNumberLabel.text = ""
//        emailLabel.text = ""
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: SettingsTableViewCell.reuseID, bundle: nil),
                           forCellReuseIdentifier: SettingsTableViewCell.reuseID)
        tableView.rowHeight = 66
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationController() {
        navigationItem.title = "Настройки"
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = K.Colors.navigationColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                   NSAttributedString.Key.font: UIFont(name: "Play", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .regular)]
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.output.settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let element = SettingsViewModel.SettingsType(rawValue: indexPath.row) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseID, for: indexPath) as! SettingsTableViewCell
        cell.setup(withOption: element)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let element = SettingsViewModel.SettingsType(rawValue: indexPath.row) else { return }
        selectedType.accept(element)
    }
}
