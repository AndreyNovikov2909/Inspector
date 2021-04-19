//
//  DeviceHeaderCollectionView.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit

class DeviceHeaderCollectionView: UICollectionReusableView {
    
    
    static let reuseID = "DeviceHeaderCollectionView"
    
    // MARK: - UI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "ValidationBackgroundSText")
        label.font = UIFont(name: "Play", size: 25)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Object livecyle

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public properties

    
    func setup(withTitle title: String) {
        titleLabel.text = title
    }
    
    // MARK: - Private properties
    
    func setupConstraints() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

