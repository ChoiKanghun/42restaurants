//
//  Store.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/21.
//

import Foundation

struct Store: Codable {
    let storeKey: String
    let storeInfo: StoreInfo
}

struct StoreInfo: Codable {
    let name: String
    let latitude: Double
    let longtitude: Double
    var rating: Double
    let mainImage: String
    var images: [String: Image]
    let createDate: Double
    let modifyDate: Double
    let category: Category.RawValue
    let enrollUser: String
    let telephone: String?
    let address: String?
    let addressDetail: String?
    var commentCount: Int
    var comments: [String: Comment]
}


