//
//  VerificationCollectionView.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit
import RxSwift
import RxCocoa

class VerificationCollectionView: UICollectionView {
    
    var password = BehaviorRelay<String>.init(value: "")
    var elements = VerificationModel.getAll()
    private let dispoeBag = DisposeBag()
    
    // MARK: - Object livecycle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: frame, collectionViewLayout: layout)
        
        update()
        setupSelf()
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public methods
    
    func remove() {
        password.accept("")
    }
    
    
    // MARK: - Setup
    
    private func update() {
        password.subscribe { [weak self] (event) in
            guard let self = self else { return }
            guard let password = event.element else { return }
            
            self.changeVerificationStatus(status: .eightSymbol, isSucccess: password.hasEightNumber)
            self.changeVerificationStatus(status: .oneUpperCase, isSucccess: password.containtsUpperCase)
            self.changeVerificationStatus(status: .oneNumber, isSucccess: password.hasNumber)
            self.changeVerificationStatus(status: .latianSymbol, isSucccess: password.latinCharactersOnly)
            self.reloadData()
        }.disposed(by: dispoeBag)
    }
    
    private func changeVerificationStatus(status: VerificationStatus, isSucccess: Bool) {
        guard var element = elements.first(where: { $0.status == status }) else { return }
        guard let index = elements.firstIndex(where: { $0.status == status }) else { return }
        element.backgroundColor = isSucccess ? VerificationStatus.eightSymbol.successBackground : VerificationStatus.eightSymbol.failureBackground
        element.textColor = isSucccess ? VerificationStatus.eightSymbol.succesTextColor : VerificationStatus.eightSymbol.failureTextColor
        element.image = isSucccess ? UIImage(named: "success") : UIImage(named: "failure")
        elements[index] = element
    }
    
    private func setupSelf() {
        register(VerificationCollectionCell.self, forCellWithReuseIdentifier: VerificationCollectionCell.reuseId)
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .green
        dataSource = self
        delegate = self
        reloadData()
    }
}


// MARK: - UICollectionViewDataSource

extension VerificationCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerificationCollectionCell.reuseId, for: indexPath) as! VerificationCollectionCell
        let model = elements[indexPath.row]
        cell.setup(withModel: model)
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension VerificationCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = elements[indexPath.row].status.title.getWidth() + 42

        return CGSize(width: width, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}


