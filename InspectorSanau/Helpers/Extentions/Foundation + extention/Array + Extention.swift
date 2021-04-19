//
//  Array + Extention.swift
//  Sanau
//
//  Created by Andrey Novikov on 3/31/21.
//

import Foundation

extension Array where Element: Hashable {
    func uniqueElements() -> [Element] {
        var seen = Set<Element>()
        
        return self.compactMap { element in
            guard !seen.contains(element)
            else { return nil }
            
            seen.insert(element)
            return element
        }
    }
}


extension Array where Element: Equatable {
    func unique() -> [Element]  {
        var arr = self
//        for (index, element) in arr.enumerated().reversed() {
//            if arr.filter({ $0 == element}).count > 1 {
//                arr.remove(at: index)
//            }
//        }
        
        return self
    }
}


extension Array {
    func chank(size: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, self.count)])
        }
    }
}

