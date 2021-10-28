//
//  Filter.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/23.
//

import Foundation

enum Filter {
    case latest
    case oldest
    case ratingHigh
    case ratingLow
    case reviewCount
    case nearest
    case imageCount
    
    var filterName: String {
        switch self {
        case .latest:
            return "최근 등록 순"
        case .oldest:
            return "오래된 순"
        case .ratingHigh:
            return "평점 높은 순"
        case .ratingLow:
            return "평점 낮은 순"
        case .reviewCount:
            return "리뷰 많은 순"
        case .nearest:
            return "가까운 순"
        case .imageCount:
            return "이미지 많은 순"
        }
    }
}
