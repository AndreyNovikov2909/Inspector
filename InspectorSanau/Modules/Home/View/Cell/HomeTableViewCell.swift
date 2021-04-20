//
//  HomeTableViewCell.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/20/21.
//

import UIKit

protocol HomeCellPresentable {
    var title: String { get set }
}

class HomeTableViewCell: UITableViewCell {

    // MARK: - External properties
    
    static let reuseID = "HomeTableViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    // MARK: - Object livecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Instance methods
    
    func setup(withMode model: HomeCellPresentable) {
        titleLabel.text = model.title
    }
}

// MARK: - SetupUI

private extension HomeTableViewCell {
    func setupUI() {
        selectionStyle = .none
        
        backView.backgroundColor = UIColor(named: "CellBackground")
        contentView.backgroundColor = UIColor(named: "background")
        titleLabel.textColor = UIColor(named: "TextColor2R")
    }
}
