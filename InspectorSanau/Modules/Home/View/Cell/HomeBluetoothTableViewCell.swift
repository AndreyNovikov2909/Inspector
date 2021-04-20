//
//  HomeDoneTableViewCell.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/20/21.
//

import UIKit


protocol HomeBluetoothCellPresentable {
    var originalName: String { get set }
    var ownerName: String { get set }
}

class HomeBluetoothTableViewCell: UITableViewCell {
    // MARK: - External properties
    
    static let reuseID = "HomeBluetoothTableViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var originalNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    // MARK: - Object livecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Instance methods
    
    func setup(withModel model: HomeBluetoothCellPresentable) {
        originalNameLabel.text = model.originalName
        fullNameLabel.text = model.ownerName
    }
}

// MARK: - SetupUI

private extension HomeBluetoothTableViewCell {
    func setupUI() {
        selectionStyle = .none
        
        backView.backgroundColor = UIColor(named: "CellBackground")
        contentView.backgroundColor = UIColor(named: "background")
        originalNameLabel.textColor = UIColor(named: "TextColor2R")
        fullNameLabel.textColor = UIColor(named: "CellDescriptionColor")
    }
}
