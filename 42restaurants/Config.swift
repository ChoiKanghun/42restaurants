//
//  Config.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/09.
//

import Foundation
import UIKit

class Config {
    static let shared = Config()
    
    private init() {}
    
    let applicationThemeColor = UIColor.init(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
}
