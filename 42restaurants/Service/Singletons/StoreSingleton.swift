//
//  StoreSingleton.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/26.
//

import Foundation

class StoreSingleton {
    static let shared = StoreSingleton()
    
    var store: Store?
    
    // 직접 인스턴스를 생성하는 것을 막는다.
    private init() { }
}
