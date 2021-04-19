//
//  RoomCollectionView.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit
import RxRelay
import RxCocoa
import RxSwift

/*
class RoomCollectionView: UICollectionView {
    
    let editingRelay = BehaviorRelay<(action: HeaderAction, isEditing: Bool)>.init(value: (.none, false))
    let appendingRoomName = PublishRelay<String>.init()
    let headerRelay = BehaviorRelay<(headerAction: HeaderAction, indexPath: IndexPath, room: HomeWrapped)?>.init(value: nil)
    let cellEditingRelay = PublishRelay<(sourceIndexPath: IndexPath, desctinationIndexPath: IndexPath)>.init()

    private let disposeBag = DisposeBag()
    private var currentHeaderState: HeaderAction = .none
    private var endEditingHeader: (() -> Void)?
    
    var elements: [HomeWrapped] = [] {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - Object livecycle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: frame, collectionViewLayout: layout)
        
        addNotifications()
        setupSelf()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func handleTap() {
        endEditing()
    }
    
    // MARK: - Setup
    
    
    private func setupSelf() {
        register(DevicesCollectionViewCell.self, forCellWithReuseIdentifier: DevicesCollectionViewCell.reuseId)
        register(RoomHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RoomHeaderCollectionView.reuseID)
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleDragAndDropCollectionViewCell)))
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = UIColor(named: "")
        dataSource = self
        delegate = self
        reloadData()
    }
    
    @objc private func handleDragAndDropCollectionViewCell(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: self)
        
        switch gesture.state {
        case .began:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()

            guard let indexPath = indexPathForItem(at: location) else {
                return
            }
            beginInteractiveMovementForItem(at: indexPath)
  
        case .changed:
            updateInteractiveMovementTargetPosition(location)
            
        case .ended:
            endInteractiveMovement()
        default:
            cancelInteractiveTransition()
        }
    }
}


// MARK: - UICollectionViewDataSource

extension RoomCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements[section].seansors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DevicesCollectionViewCell.reuseId, for: indexPath) as! DevicesCollectionViewCell
        let item = elements[indexPath.section].seansors[indexPath.row]
        cell.setup(model: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RoomHeaderCollectionView.reuseID, for: indexPath) as! RoomHeaderCollectionView
        let title = elements[indexPath.section].title
        header.headerAction = (title: title,
                               isEditing: editingRelay.value.isEditing,
                               action: editingRelay.value.action,
                               indexPath: indexPath)
                
        header.myDelegate = self
        
        if indexPath.section == elements.count - 1 {
            endEditingHeader = header.endEditingColpmlition
        }
        
        return header
    }
}

extension RoomCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceItem = elements[sourceIndexPath.section].seansors.remove(at: sourceIndexPath.row)
        elements[destinationIndexPath.section].seansors.insert(sourceItem, at: destinationIndexPath.row)
        cellEditingRelay.accept((sourceIndexPath: sourceIndexPath, desctinationIndexPath: destinationIndexPath))
    }
}

// MARK: - Control

extension RoomCollectionView {
    func delete() {
        editingRelay.accept((HeaderAction.remove, true))
        currentHeaderState = .remove
        reloadData()
    }
    
    func append() {
        editingRelay.accept((HeaderAction.append, true))
        currentHeaderState = .append
        reloadData()
        self.setContentOffset(CGPoint(x: 0, y: contentSize.height - frame.size.height + 50), animated: true)
        let indexPath = IndexPath(item: 0, section: elements.count)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let header = self.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath) as! RoomHeaderCollectionView
            header.titleTextField.isEnabled = true
            header.titleTextField.becomeFirstResponder()
        }
    }
    
    func endEditing() {
        editingRelay.accept((action: HeaderAction.none, isEditing: false))
        reloadData()
    }
    
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(animateIn), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateOut), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func animateIn(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let timeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        guard let curveValue = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else { return }
        let option = UIView.AnimationOptions(rawValue: curveValue)

        UIView.animate(withDuration: timeInterval, delay: 0, options: option) {
            self.contentInset.bottom = keyboardSize.height
        }
    }
    
    @objc private func animateOut(notification: Notification) {
        guard let timeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        guard let curveValue = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else { return }
        let option = UIView.AnimationOptions(rawValue: curveValue)

        
        UIView.animate(withDuration: timeInterval, delay: 0, options: option) {
            self.contentInset.bottom = 0
            self.reloadData()
        }
        
        if currentHeaderState == .append {
            endEditingHeader?()
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension RoomCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets: CGFloat = (16 * 2)/2 + 8
        
        let width = UIScreen.main.bounds.width / 2 - insets
        let height = width / 1.6
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: frame.width, height: 50)
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 20, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}


// MARK: - RoomHeaderCollectionViewDelegate

extension RoomCollectionView: RoomHeaderCollectionViewDelegate {
    func roomHeaderCollectionView(_ roomHeaderCollectionView: RoomHeaderCollectionView,
                                  didEditingButtonTapped button: UIButton,
                                  withHeaderAction action: HeaderAction,
                                  atIndexPath indexPath: IndexPath) {
        
        headerRelay.accept((headerAction: action, indexPath: indexPath, room: elements[indexPath.section]))
    }
    
    func roomHeaderCollectionView(_ roomHeaderCollectionView: RoomHeaderCollectionView, didEndEditingWithRoomName roomName: String?) {
        if currentHeaderState == .append {
            editingRelay.accept((HeaderAction.append, true))
            appendingRoomName.accept(roomName ?? "")
        }
    }
}

*/
