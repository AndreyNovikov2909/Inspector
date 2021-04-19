//
//  SettingsTableViewCell.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/14/21.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    // MARK: External protpies
    
    static let reuseID = "SettingsTableViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var bubleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    // MARK: - Object livecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Setup
    
    func setup(withOption option: SettingsViewModel.SettingsType) {
        titleLabel.text = option.title
    }
}

private extension SettingsTableViewCell {
    func setupUI() {
        selectionStyle = .none

        
        bubleView.layer.cornerRadius = 5
        bubleView.backgroundColor = UIColor(named: "viewBackground")
        contentView.backgroundColor = UIColor(named: "background")
        titleLabel.textColor = UIColor(named: "mainTitle")
        imageview.image = UIImage(named: "arraowDeg")
    }
}
