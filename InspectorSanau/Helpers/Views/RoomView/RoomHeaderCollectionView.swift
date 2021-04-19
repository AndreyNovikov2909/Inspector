//
//  RoomHeaderCollectionView.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

/*
enum HeaderAction {
    case append
    case remove
    case none
    
    var image: UIImage? {
        switch self {
        case .append:
            return UIImage(named: "remove")
        case .remove:
            return UIImage(named: "remove")
        default: return nil
        }
    }
}

protocol RoomHeaderCollectionViewDelegate: class {
    func roomHeaderCollectionView(_ roomHeaderCollectionView: RoomHeaderCollectionView,
                                  didEditingButtonTapped button: UIButton,
                                  withHeaderAction action: HeaderAction,
                                  atIndexPath indexPath: IndexPath)
    
    func roomHeaderCollectionView(_ roomHeaderCollectionView: RoomHeaderCollectionView, didEndEditingWithRoomName roomName: String?)
}

class RoomHeaderCollectionView: UICollectionReusableView {
    
    static let reuseID = "RoomHeaderCollectionView"
    weak var myDelegate: RoomHeaderCollectionViewDelegate?
    
    var headerViewModel: RoomHeaderCollectionViewViewModelPresentable!
    var headerAction: (title: String, isEditing: Bool, action: HeaderAction, indexPath: IndexPath)? {
        didSet {
            if let action = headerAction {
                setup(withTitle: action.title, isEditing: action.isEditing, action: action.action)
            }
        }
    }
    
    private let disposeBag = DisposeBag()
    var endEditingColpmlition: (() -> Void)?
    
    // MARK: - UI
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.contentHorizontalAlignment = .center
        textField.contentVerticalAlignment = .center
        textField.textColor = UIColor(named: "ValidationBackgroundSText")
        textField.font = UIFont(name: "Play", size: 25)
        textField.backgroundColor = .clear
        textField.textAlignment = .center
        textField.textAlignment = .left
        textField.isEnabled = false
        return textField
    }()
    
    var editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handleEditingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var widthTitleTextFeild: NSLayoutConstraint!
    
    // MARK: - Object livecyle

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        setupViewModel()
        binding()
        
        endEditingColpmlition = {
            self.myDelegate?.roomHeaderCollectionView(self, didEndEditingWithRoomName: self.titleTextField.text)
        }
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleEditingButtonTapped(sender: UIButton) {
        guard let action = headerAction else { return }
        myDelegate?.roomHeaderCollectionView(self, didEditingButtonTapped: sender, withHeaderAction: action.action, atIndexPath: action.indexPath)
    }
    
    // MARK: - Public properties

    
    private func setup(withTitle title: String, isEditing: Bool, action: HeaderAction) {
        titleTextField.text = title
        widthTitleTextFeild.constant = titleTextField.intrinsicContentSize.width
        
        editingButton.isHidden = !isEditing
        editingButton.setImage(action.image, for: .normal)
        editingButton.tintColor = UIColor(named: "ValidationBackgroundSText")
        
        switch action {
        case .append:
            editingButton.isHidden = true
            titleTextField.isEnabled = false

        case .remove:
            editingButton.isHidden = false
            titleTextField.isEnabled = false

        case .none:
            editingButton.isHidden = true
            titleTextField.isEnabled = false
        }
    }
    
    
    // MARK: - Setup View model
    
    private func setupViewModel() {
        headerViewModel = RoomHeaderCollectionViewViewModel(input: (headerFrame: frame,
                                                                    indexPath: headerAction?.indexPath,
                                                                    headerText: titleTextField.rx.text.orEmpty.asDriver()))
        
    }
    
    private func binding() {
        headerViewModel.output.widthAchor.drive(widthTitleTextFeild.rx.constant).disposed(by: disposeBag)
    }
    
    // MARK: - Private properties
    
    func setupConstraints() {
        addSubview(titleTextField)
        addSubview(editingButton)
        
        
        widthTitleTextFeild = titleTextField.widthAnchor.constraint(equalToConstant: titleTextField.intrinsicContentSize.width)
        widthTitleTextFeild.isActive = true
        
        titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17).isActive = true
        titleTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            editingButton.heightAnchor.constraint(equalToConstant: 25),
            editingButton.widthAnchor.constraint(equalToConstant: 25),
            editingButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            editingButton.leadingAnchor.constraint(equalTo: titleTextField.trailingAnchor, constant: 6)
        ])
    }
}

*/
