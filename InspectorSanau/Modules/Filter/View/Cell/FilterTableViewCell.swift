//
//  FilterTableViewCell.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/23/21.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    static let reuseID = "FilterTableViewCell"

    // MARK: - IBOutlets
    
    @IBOutlet weak var bubleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Object livecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    
    // MARK: - Setup
    
    func setup(withModel model: FilterViewModel.FilterItem) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
}

private extension FilterTableViewCell {
    func setupUI() {
        selectionStyle = .none

        bubleView.layer.cornerRadius = 5
        bubleView.backgroundColor = UIColor(named: "viewBackground")
        contentView.backgroundColor = UIColor(named: "background")
        titleLabel.textColor = UIColor(named: "mainTitle")
        arrowImageView.image = UIImage(named: "arraowDeg")
        descriptionLabel.textColor = UIColor(named: "CellDescriptionColor")
    }
}
