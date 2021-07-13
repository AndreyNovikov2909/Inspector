//
//  MainDescriptionViewController.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/19/21.
//

import UIKit
import RxSwift
import RxCocoa

class MainDescriptionViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var devicesButton: UIButton!
    @IBOutlet weak var roomsButton: UIButton!
    @IBOutlet weak var underView: UIView!
    @IBOutlet weak var overView: UIView!
    
    var builder: MainDescriptionViewModelPresentable.Builder!
    private var viewMoedel: MainDescriptionViewModelPresentable!
    private var handleExel = PublishRelay<Void>.init()
    private let dispose = DisposeBag()
    
    // MARK: - UI
    
    lazy var exelVC: ExportExelViewController = {
        let exelVC: ExportExelViewController = UIStoryboard.loadViewController()
        print(exelVC.view)
        return exelVC
    }()

    
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
        viewMoedel = builder((exelButton: exelVC.acceptButton.rx.tap.asDriver(),
                              fileName: exelVC.emailTextView.messageTextField.rx.text.orEmpty.asDriver(),
                              firstDate: exelVC.leftTextField.rx.text.orEmpty.asDriver(),
                              lastDate: exelVC.rigthTextField.rx.text.orEmpty.asDriver()))
                             
        viewMoedel.output.success.asObservable().subscribe { (event) in
            if let url = event.element {
                let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                activityViewController.excludedActivityTypes = [.message, .airDrop, .mail]
                activityViewController.isModalInPresentation = true
                self.exelVC.dismiss(animated: true) {
                    self.present(activityViewController, animated: true, completion: nil)
                }
            }
        }.disposed(by: dispose)
        
        viewMoedel.output.buttonIsActive.asObservable().subscribe { (event) in
            if let enable = event.element {
                self.exelVC.acceptButton.buttonIsEnable(value: enable)
                return
            }
        }.disposed(by: dispose)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addNotifications()
        setupNavigation()
        setupNavigationItem(imageName: "Excel")
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeNotifications()
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
        present(exelVC, animated: true, completion: nil)
        handleExel.accept(Void())
    }
    
    // MARK: - Keyboard
    
    @objc private func animateIn(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let timeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        guard let curveValue = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else { return }
        let option = UIView.AnimationOptions(rawValue: curveValue)

      
        UIView.animate(withDuration: timeInterval, delay: 0, options: option) {
            self.exelVC.view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
        }
    }
    
    @objc private func animateOut(notification: Notification) {
        guard let timeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        guard let curveValue = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else { return }
        let option = UIView.AnimationOptions(rawValue: curveValue)


        UIView.animate(withDuration: timeInterval, delay: 0, options: option) {
            self.exelVC.view.transform = .identity
        }
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: imageName,
                                                            style: .plain,
                                                            target: self, action: #selector(handleRightButtonTapped))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "TextColor3")
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.barTintColor = K.Colors.navigationColor
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(animateIn), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateOut), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
