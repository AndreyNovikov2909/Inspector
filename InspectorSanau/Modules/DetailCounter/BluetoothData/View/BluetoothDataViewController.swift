//
//  BluetoothDataViewController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/19/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController


class BluetoothDataViewController: UIViewController {
    
    // MARK: - UI

    private var graphView: GraphView!
    private var tableView: UITableView!
    private var acceptButton: UIButton!
    
    // MARK: - ViewModel

    var builder: BluetoothDataViewModelPresentable.Builder!
    private var viewModel: BluetoothDataViewModelPresentable!

    
    // MARK: - Private properties
    
    private let saveTap = PublishRelay<Void>.init()
    private let dispose = DisposeBag()
    private var bluetoothPressentable = [BluetoothPresentable]()


    // MARK: - Object livecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupViewModel()
        bindind()
    }
}


// MARK: - Setup ViewModel

private extension BluetoothDataViewController {
    func setupViewModel() {
        let input = (loadData: rx.viewWillAppear.asDriver().map({ _ in }),
                     saveTap: saveTap.asDriver(onErrorDriveWith: .never()),
                     viewDidDisappear: rx.viewDidDisappear.map({ _ in  }).asDriver(onErrorDriveWith: .never()),
                     viewWillAppear: rx.viewWillAppear.map({_ in }).asDriver(onErrorDriveWith: .never()))
        viewModel = builder(input)
    }

    func bindind() {
        viewModel.output.dataPresentable.asObservable().subscribe { [weak self] (event) in
            guard let self = self else { return }
            guard let value = event.element else { return }
            
            self.graphView.data = value
            self.bluetoothPressentable = value
            self.acceptButton.setTitle("Считать данные", for: .normal)
            self.tableView.reloadData()
            
            print("DEBUG: \(value)")
        }.disposed(by: dispose)
    }

}

// MARK: - Setup UI

private extension BluetoothDataViewController {
    func setupUI() {
        setupSelf()
        setupGraphView()
        setupAcceptButton()
        setupTableView()
    }

    func setupGraphView() {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width / 2)
        graphView = GraphView(frame: frame)
        graphView.backgroundColor = .clear
        graphView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(graphView)

        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graphView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2)
        ])
    }
    
    func setupAcceptButton() {
        acceptButton = UIButton(type: .system)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.setTitle("Считывание...", for: .normal)
        acceptButton.titleLabel?.font = UIFont(name: "Play", size: 17)
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.backgroundColor = UIColor(named: "TextColor2")
        
        acceptButton.rx.tap.asObservable().subscribe { _ in
            self.acceptButton.setTitle("Считывание...", for: .normal)
            self.saveTap.accept(Void())
        }.disposed(by: dispose)
        
        view.addSubview(acceptButton)
        
        NSLayoutConstraint.activate([
            acceptButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            acceptButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            acceptButton.heightAnchor.constraint(equalToConstant: 50),
            acceptButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: BluetoothDataViewControllerTitleTableViewCell.reuseId, bundle: nil),
                           forCellReuseIdentifier: BluetoothDataViewControllerTitleTableViewCell.reuseId)
        tableView.register(UINib(nibName: ElectrinicMetterTableViewCell.reuseId, bundle: nil),
                           forCellReuseIdentifier: ElectrinicMetterTableViewCell.reuseId)
        
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: acceptButton.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }



    func setupSelf() {
        view.backgroundColor = UIColor(named: "BackViewColor")
    }
}



// MARK: - UITableViewDataSource

extension BluetoothDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bluetoothPressentable.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // title cell
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BluetoothDataViewControllerTitleTableViewCell.reuseId, for: indexPath) as! BluetoothDataViewControllerTitleTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ElectrinicMetterTableViewCell.reuseId, for: indexPath) as! ElectrinicMetterTableViewCell
            cell.setup(withPresentable: bluetoothPressentable[indexPath.row - 1], indexPath: IndexPath(row: indexPath.row - 1, section: indexPath.section))
            cell.needShowComplite.subscribe { _ in
                self.bluetoothPressentable[0].needToShow = false
            }.disposed(by: dispose)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // title cell
        if indexPath.row == 0 {
            return 60
        } else {
            
            // default
            return 40
        }
    }
}


// MARK: - UITableViewDelegate

extension BluetoothDataViewController: UITableViewDelegate {
    
}
