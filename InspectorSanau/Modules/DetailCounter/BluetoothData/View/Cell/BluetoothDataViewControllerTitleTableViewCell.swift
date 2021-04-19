//
//  BluetoothDataViewControllerTitleTableViewCell.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/19/21.
//

import UIKit


class BluetoothDataViewControllerTitleTableViewCell: UITableViewCell {
    
    // MARK: - External properties
    
    static let reuseId = "BluetoothDataViewControllerTitleTableViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    // MARK: - Object livecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}


// MARK: - Setup UI

private extension BluetoothDataViewControllerTitleTableViewCell {
    func setupUI() {
        setupSelf()
        setupLabels()
    }
    
    func setupSelf() {
        selectionStyle = .none
        backgroundColor = UIColor(named: "bac1")
    }
    
    func setupLabels() {
        dateLabel.textColor = UIColor(named: "textColor")
        valueLabel.textColor = UIColor(named: "textColor")
        
        dateLabel.text = "Дата"
        valueLabel.text = "Данные"
    }
}
