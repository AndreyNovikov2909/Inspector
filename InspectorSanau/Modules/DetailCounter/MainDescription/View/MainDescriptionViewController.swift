//
//  MainDescriptionViewController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/19/21.
//

import UIKit

class MainDescriptionViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var devicesButton: UIButton!
    @IBOutlet weak var roomsButton: UIButton!
    @IBOutlet weak var underView: UIView!
    @IBOutlet weak var overView: UIView!
    
    // MARK: - UI
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .clear
        scrollView.delegate = self
        
        let numberOfViewController: CGFloat = 2
        let contentSize = CGSize(width: view.frame.width * numberOfViewController, height: scrollView.frame.height)
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    // MARK: - Object livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigation()
    }
    
    // MARK: - IBAction
    
    @IBAction func devicesButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset.x = 0
        }
    }
        
    @IBAction func roomsButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.33) {
            self.scrollView.contentOffset.x = self.view.frame.width
        }
    }
    
    // MARK: - Selector methods
    
    @objc private func handleRightButtonTapped() {
        
    }
}


// MARK: - Setup UI

private extension MainDescriptionViewController {
    func setupUI() {
        setupView()
        setupLabelStack()
        setupUnderViews()
        setupScrollView()
    }
    
    func setupView() {
        view.backgroundColor = K.Colors.navigationColor
        backView.backgroundColor = K.Colors.backViewColor
        backView.layer.cornerRadius = 33
    }
    
    func setupLabelStack() {
        stackView.backgroundColor = .clear
        
        devicesButton.setTitle("ДАННЫЕ", for: .normal)
        roomsButton.setTitle("ОПИСАНИЕ", for: .normal)
        
        devicesButton.setTitleColor(UIColor(named: "HomeTextColor2"), for: .normal)
        roomsButton.setTitleColor(UIColor(named: "HomeTextColor1"), for: .normal)
    }
        
    func setupUnderViews() {
        underView.backgroundColor = UIColor(named: "UnderViewColor")
        overView.backgroundColor = UIColor(named: "OverViewColorSet")
        
        let x = devicesButton.frame.width - devicesButton.intrinsicContentSize.width
        overView.frame.size.width = devicesButton.intrinsicContentSize.width
        overView.frame.origin.x = x / 2
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        
        scrollView.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width,
                                                              height: view.frame.height))
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: underView.bottomAnchor, constant: 3),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupNavigationItem(imageName: String) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: imageName),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(handleRightButtonTapped))
        
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.barTintColor = K.Colors.navigationColor
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "C7J1236"
    }
}


// MARK: - UIScrollViewDelegate
 
extension MainDescriptionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = devicesButton.frame.width - devicesButton.intrinsicContentSize.width
        let transform = scrollView.contentOffset.x / 2 + x / 2
        overView.frame.origin.x = transform
        
        switch scrollView.contentOffset.x {
        case -1000...view.frame.width * 0.5:
            devicesButton.setTitleColor(UIColor(named: "HomeTextColor2"), for: .normal)
            roomsButton.setTitleColor(UIColor(named: "HomeTextColor1"), for: .normal)
        default:
            roomsButton.setTitleColor(UIColor(named: "HomeTextColor2"), for: .normal)
            devicesButton.setTitleColor(UIColor(named: "HomeTextColor1"), for: .normal)
        }
    }
}
