//
//  TypeMetterTableViewCell.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/23/21.
//

import UIKit

class TypeMetterTableViewCell: UITableViewCell {

    // MARK: - External propties
    
    static let reuseID = "TypeMetterTableViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bubleView: UIView!
    @IBOutlet weak var acceptImageView: UIImageView!
    
    // MARK: - Object livecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Instance methods
    
    func setup(withModel model: TypeMetterViewModel.TypeMetter) {
        titleLabel.text = model.title
        
        let imageIsHidden = DefaultsService.shared.getCurrenctPhase() == model
        acceptImageView.isHidden = !imageIsHidden
    }
}

// MARK: - SetupUI

private extension TypeMetterTableViewCell {
    func setupUI() {
        selectionStyle = .none

        acceptImageView.contentMode = .scaleAspectFit
        bubleView.layer.cornerRadius = 5
        bubleView.backgroundColor = UIColor(named: "viewBackground")
        contentView.backgroundColor = UIColor(named: "background")
        titleLabel.textColor = UIColor(named: "mainTitle")
    }
}

