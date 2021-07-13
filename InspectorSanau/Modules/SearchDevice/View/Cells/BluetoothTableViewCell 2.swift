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
    
    
    let realm = try! RealmService()
    
    // MARK: - Object livecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    func setup(withModel model: BluetoothCellPresentable) {
        titleLabel.text = model.name
        
        self.titleLabel.textColor = UIColor(named: "TextColor2R")
        
        guard let fromDate = UserDefaults.standard.value(forKey: model.name) as? Date else { return }
        
        if fromDate.timeIntervalSinceNow + (24 * 60 * 60) > Date().timeIntervalSinceNow {
            self.titleLabel.textColor = .green
        }
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
