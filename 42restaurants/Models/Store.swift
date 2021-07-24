//
//  Store.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/21.
//

import Foundation

struct Store: Codable {
    let name: String
    let latitude: Double
    let longtitude: Double
    let rating: Double
    let image: String
    let createDate: String
    let modifyDate: String
    let category: Category.RawValue
    let enrollUser: String
    let telephone: String?
    let address: String?
}
