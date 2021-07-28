//
//  Comments.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/28.
//

import Foundation

struct Comments: Codable {
    let commentKey: String
    let comment: Comment
}

struct Comment: Codable {
    let rating: Double
    let description: String
    let userId: String
    let images: Dictionary<String, String>
    
}

