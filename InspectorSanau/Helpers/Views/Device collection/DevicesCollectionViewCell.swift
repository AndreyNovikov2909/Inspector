//
//  DevicesCollectionViewCell.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit

/*
class DevicesCollectionViewCell: UICollectionViewCell {
    static let reuseId = "DevicesCollectionViewCell"
    
    private let bubleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(named: "CellBackground")
        return view
    }()
    
    let backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.tintColor = UIColor(named: "CellBackground")
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Play", size: 16)
        label.textColor = UIColor(named: "CellTextColor")
        label.textAlignment = .center
        return label
    }()
    
    
    // MARK: - Object livecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Instance methods

    func setup(model: SensorModel) {
        self.titleLabel.text = model.description
        self.backImageView.image = model.presentableImage
    }
    
    // MARK: - Private methods
    
    private func setupConstraints() {
        contentView.addSubview(bubleView)
        bubleView.addSubview(backImageView)
        bubleView.addSubview(titleLabel)
        
        // bubleView
        NSLayoutConstraint.activate([
            bubleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bubleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bubleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bubleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        // backImageView
        NSLayoutConstraint.activate([
            backImageView.centerXAnchor.constraint(equalTo: bubleView.centerXAnchor),
            backImageView.topAnchor.constraint(equalTo: bubleView.topAnchor, constant: 20),
            backImageView.heightAnchor.constraint(equalToConstant: 29.5),
            backImageView.widthAnchor.constraint(equalToConstant: 29.5)
        ])
        
        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: bubleView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: bubleView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: backImageView.bottomAnchor, constant: 6.5)
        ])
    }
}


*/
