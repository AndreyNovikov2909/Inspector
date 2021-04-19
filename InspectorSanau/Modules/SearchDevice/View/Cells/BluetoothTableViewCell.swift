//
//  BluetoothTableViewCell.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/16/21.
//

import UIKit

class BluetoothTableViewCell: UITableViewCell {

    static let reuseID = "BluetoothTableViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Object livecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    func setup(withModel model: BluetoothCellPresentable) {
        titleLabel.text = model.name
    }
}

// MARK: - Setup UI

private extension BluetoothTableViewCell {
    func setupUI() {
        selectionStyle = .none
        backView.backgroundColor = UIColor(named: "CellBackground")
        contentView.backgroundColor = UIColor(named: "background")
        
        titleLabel.textColor = UIColor(named: "TextColor2R")
    }
}
