//
//  HomeDoneTableViewCell.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/20/21.
//

import UIKit


protocol HomeBluetoothTableViewCellDegate: class {
    func homeBluetoothTableViewCellDidSelect(_ homeBluetoothTableViewCell: HomeBluetoothTableViewCell)
}

protocol HomeBluetoothCellPresentable {
    var originalName: String { get set }
    var ownerName: String { get set }
//    var isReadOut: Bool { get set }
}

class HomeBluetoothTableViewCell: UITableViewCell {
    // MARK: - External properties
    
    static let reuseID = "HomeBluetoothTableViewCell"
    weak var myDelegate: HomeBluetoothTableViewCellDegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var originalNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    
    let realm = try! RealmService()
    
    // MARK: - Object livecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

    }
    
    @objc private func handleTap() {
        myDelegate?.homeBluetoothTableViewCellDidSelect(self)
    }
    
    // MARK: - Instance methods
    
    func setup(withModel model: HomeBluetoothCellPresentable) {
        originalNameLabel.text = model.originalName
        fullNameLabel.text = model.ownerName
        // !pres.contains(where: { $0.date.getDayFromDate() == $0.date.getDayFromToday() })
        let value: DeviceObject? = realm.getObjects().filter({ $0.originalName == model.originalName }).first 
        self.originalNameLabel.textColor = UIColor(named: "TextColor2R")
        value?.scanList.forEach({ (object) in
            
            print(model.originalName)
            print(object.date?.checkContantsDate())
            print(object.date)
            
            if object.date?.checkContantsDate() != nil {
                self.originalNameLabel.textColor = .green
            } else {
                self.originalNameLabel.textColor = UIColor(named: "TextColor2R")
            }

        })
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


extension String {
    func checkContantsDate() -> Bool {
        let today = Date()
        let calndar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
       
        if let date = dateFormatter.date(from: self) {
            let todayDay = calndar.component(.day, from: today)
            let fromDay = calndar.component(.day, from: date)
            
            return todayDay == fromDay
        }
        
        return false
    }
}
