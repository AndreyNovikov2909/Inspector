//
//  VerificationModel.swift
//  Sanau
//
//  Created by Andrey Novikov on 2/19/21.
//

import UIKit.UIColor

struct VerificationModel {
    var status: VerificationStatus
    var backgroundColor: UIColor?
    var textColor: UIColor?
    var image: UIImage?
}

extension VerificationModel {
    static func getAll() -> [VerificationModel] {
        var model: [VerificationModel] = []
        
        VerificationStatus.allCases.forEach { (status) in
            let elemnt = VerificationModel(status: status,
                                           backgroundColor: status.failureBackground,
                                           textColor: status.failureTextColor,
                                           image: UIImage(named: "failure"))
            model.append(elemnt)
        }
        
        return model
    }
}
