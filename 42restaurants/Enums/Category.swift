//
//  Category.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/21.
//

import Foundation

enum Category: String {
    case koreanAsian = "한식/아시안"
    case mexican = "멕시코 음식"
    case japaneseCutlet = "일식/돈까스"
    case chinese = "중식"
    case western = "양식"
    case meat = "고기집"
    case bunsik = "분식"
    case cafe = "카페"
    case fastFood = "패스트푸드"
    case chickenPizza = "치킨/피자"
    
    var imageName: String {
        switch self {
        case .koreanAsian:
            return "korean"
        case .mexican:
            return "mexican"
        case .japaneseCutlet:
            return "japanese"
        case .chinese:
            return "chinese"
        case .western:
            return "western"
        case .meat:
            return "meat"
        case .cafe:
            return "cafe"
        case .chickenPizza:
            return "chickenPizza"
        case .fastFood:
            return "fastFood"
        case .bunsik:
            return "bunsik"
        }
    }
}

