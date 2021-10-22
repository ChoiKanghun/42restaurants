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
    
    let applicationThemeColor = UIColor.init(red:44/255, green: 62/255, blue: 80/255, alpha: 1)
    let application60Color = UIColor.white
//    let application30Color = UIColor.init(red:190/255, green: 215/255, blue: 252/255, alpha: 1)
    let application30Color = UIColor.white
    let application10Color = UIColor.white
//    let application10Color = UIColor.init(red: 44, green: 62, blue: 80, alpha: 1)
    let applicationContrastTextColor = UIColor.black
    let applicationSupplimetaryTextColor = UIColor.gray
    //230 239 252 연파랑
    //222 228 252 연보라색
    //#2c3e50  44 62 80고급남색
    let applicationSupplimentaryBackgroundColor = UIColor.gray
    let applicationFontLightColor = UIColor.systemGray3
    let applicationFontDefaultColor = UIColor.black
}
