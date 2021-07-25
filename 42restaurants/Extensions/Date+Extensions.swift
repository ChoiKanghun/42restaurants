//
//  Date+Extensions.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/21.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
    
    func toDouble() -> Double {
        return self.timeIntervalSince1970
    }
}
