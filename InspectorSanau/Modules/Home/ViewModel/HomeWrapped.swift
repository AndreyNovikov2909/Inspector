//
//  HomeWrapped.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/20/21.
//

import Foundation


struct HomeWrapped  {
    var count: Int = Int.random(in: 1000...10000)
    var homeItems: [HomeDetailWrapped]
}

struct HomeDetailWrapped: HomeCellPresentable, HomeBluetoothCellPresentable {
    var title: String
    
    var originalName: String
    var ownerName: String
    
    init(title: String) {
        self.title = title
        
        originalName = ""
        ownerName = ""
    }
    
    init(originalName: String, ownerName: String) {
        self.originalName = originalName
        self.ownerName = ownerName
        
        title = ""
    }
}
