//
//  DescriptionTableViewCell.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/20/21.
//

import UIKit

protocol DescriptionPresentable {
    var leftTitle: String { get set }
    var rightTitle: String { get set }
}

class DescriptionTableViewCell: UITableViewCell {

    // MARK: - Exatranl protpies
    
    static let reuseID = "DescriptionTableViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    // MARK: - Object livecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Instance methods
    
    func setup(withDescriptionPresentable description: DescriptionPresentable) {
        leftLabel.text = description.leftTitle
        rightLabel.text = description.rightTitle
    }
}


// MARK: - Setup UI

private extension DescriptionTableViewCell {
    func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = UIColor(named: "BackViewColor")
        leftLabel.textColor = UIColor(named: "TextColor1.1")
        rightLabel.textColor = UIColor(named: "TextColor1.1")
        bottomView.backgroundColor = UIColor(named: "ViewBottomColor")
    }
}
