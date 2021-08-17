//
//  MainTabStoreSingleton.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/08/17.
//

import Foundation

class MainTabStoreSingleton {
    static let shared = MainTabStoreSingleton()
    
    var store: Store?
    
    // 직접 인스턴스를 생성하는 것을 막는다.
    private init() { }
}
