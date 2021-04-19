//
//  ElectrinicMetterTableViewCell.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/19/21.
//

import UIKit
import RxSwift
import RxCocoa

class ElectrinicMetterTableViewCell: UITableViewCell {

    // MARK: - External prpoerties
    
    static let reuseId = "ElectrinicMetterTableViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    // MARK: - Instance propties
    
    var needShowComplite = PublishRelay<Void>.init()
    
    // MARK: - Private properties
    
    private var indexPath: IndexPath?
    
    // MARK: - Object livecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Instance properties
    
    func setup(withPresentable presentable: ElectromicMetter2Presentable, indexPath: IndexPath) {
        dateLabel.text = presentable.date
        valueLabel.text = "\(presentable.value)"
        self.indexPath = indexPath
        contentView.backgroundColor = getBackground(indexPath: indexPath)
        
        if indexPath.row == 0 && presentable.needToShow {
            changeColor()
        }
    }
    
    func changeColor() {
        changeColor(background: UIColor(named: "green"), titleColor: .white)
        needShowComplite.accept(Void())
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] (timer) in
            guard let self = self else { return }
            
            self.changeColor(background: self.getBackground(indexPath: self.indexPath), titleColor: UIColor(named: "textColor"))
            timer.invalidate()
        }
    }
    
    private func changeColor(background: UIColor?, titleColor: UIColor?) {
        UIView.animate(withDuration: 0.45) {
            self.valueLabel.textColor = titleColor
            self.dateLabel.textColor = titleColor
            self.contentView.backgroundColor = background
        }
    }
    
    private func getBackground(indexPath: IndexPath?) -> UIColor? {
        if (indexPath?.row ?? 0) % 2 == 0 {
            return UIColor(named: "bac2")
        } else {
            return  UIColor(named: "bac1")
        }
    }
}

// MARK: - SetupUI

private extension ElectrinicMetterTableViewCell {
    func setupUI() {
        setupSelf()
    }
    
    func setupSelf() {
        selectionStyle = .none
        dateLabel.textColor = UIColor(named: "textColor")
        valueLabel.textColor = UIColor(named: "textColor")
    }
}
