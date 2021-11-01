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
    // 맨 처음 application30Color로 쓰려던 색
//    let application30Color = UIColor.init(red:190/255, green: 215/255, blue: 252/255, alpha: 1)
    let application30Color = UIColor.white
    let application10Color = UIColor.white
//    let application10Color = UIColor.init(red: 44, green: 62, blue: 80, alpha: 1)
    let applicationContrastTextColor = UIColor.black
    let applicationSupplimetaryTextColor = UIColor.gray
    //230 239 252 연파랑
    //222 228 252 연보라색
    //#2c3e50  44 62 80고급남색
    
    /* BackGround */
    let applicationSupplimentaryBackgroundColor = UIColor.gray
    let applicationBackgroundLightGrayColor: UIColor = .lightGray
    let applicationOnSelectedBackgroundColor = UIColor.init(displayP3Red: 190/255, green: 215/255, blue: 252/255, alpha: 1)
    
    /* FONT */
    let applicationFontLightColor = UIColor.systemGray3
    let applicationFontDefaultColor = UIColor.black
    let applicationOnSelectedTextColor = UIColor.init(displayP3Red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
    
    
    
    
}
