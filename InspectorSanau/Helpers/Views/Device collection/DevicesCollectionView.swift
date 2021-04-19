//
//  DevicesCollectionView.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//


import UIKit
import RxSwift
import RxCocoa
import RxRelay

/*
class DevicesCollectionView: UICollectionView {
    
    let elements = HomeWrapped.getElements()
    var selectedRelay = PublishRelay<(IndexPath, SensorModel)>.init()
    
    // MARK: - Object livecycle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupSelf()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup
    
    
    private func setupSelf() {
        register(DevicesCollectionViewCell.self, forCellWithReuseIdentifier: DevicesCollectionViewCell.reuseId)
        register(DeviceHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DeviceHeaderCollectionView.reuseID)
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = UIColor(named: "")
        dataSource = self
        delegate = self
        reloadData()
    }
}


// MARK: - UICollectionViewDataSource

extension DevicesCollectionView: UICollectionViewDataSource {
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
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DeviceHeaderCollectionView.reuseID, for: indexPath) as! DeviceHeaderCollectionView
        let title = elements[indexPath.section].title
        header.setup(withTitle: title)
        return header
    }
}


extension DevicesCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRelay.accept((indexPath, elements[indexPath.section].seansors[indexPath.row]))
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension DevicesCollectionView: UICollectionViewDelegateFlowLayout {
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


*/
