//
//  Date + extention.swift
//  Sanau
//
//  Created by Andrey Novikov on 3/31/21.
//

import Foundation

extension Date {
    func getCurentDate(formate: String = "dd/MM/YYYY HH:mm") -> String {
        let df = DateFormatter()
        df.dateFormat = formate
        return df.string(from: self)
    }
}
