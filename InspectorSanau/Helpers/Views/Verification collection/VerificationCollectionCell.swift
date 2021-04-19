//
//  VerificationCollectionCell.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit

class VerificationCollectionCell: UICollectionViewCell {
    static let reuseId = "VerificationCollectionCell"
    
    private let bubleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    let backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont(name: "Play", size: 13)
        return label
    }()
    
    
    
    // MARK: - Object livecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    
    func setup(withModel model: VerificationModel) {
        bubleView.backgroundColor = model.backgroundColor
        backImageView.image = model.image
        titleLabel.textColor = model.textColor
        titleLabel.text = model.status.title
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
            bubleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            bubleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
        
        // backImageView
        NSLayoutConstraint.activate([
            backImageView.leadingAnchor.constraint(equalTo: bubleView.leadingAnchor, constant: 15),
            backImageView.centerYAnchor.constraint(equalTo: bubleView.centerYAnchor),
            backImageView.widthAnchor.constraint(equalToConstant: 12),
            backImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: bubleView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backImageView.trailingAnchor, constant: 7),
            titleLabel.trailingAnchor.constraint(equalTo: bubleView.trailingAnchor, constant: 8)
        ])
    }
}

