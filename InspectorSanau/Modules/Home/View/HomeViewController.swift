//
//  HomeViewController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    // MARK: - Objetc livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationController()
    }
}


// MARK: - SetupUI

private extension HomeViewController {
    
    func setupNavigationController() {
        navigationItem.title = "Устройства"
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
