//
//  String+Extensions.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/21.
//

import Foundation

extension String {
    func toDate() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
        
    }
}
