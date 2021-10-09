//
//  MainTabBarController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/09.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setTabBarColors()
    }
    
    private func setTabBarColors() {
        tabBar.barTintColor = Config.shared.applicationThemeColor
        tabBar.isTranslucent = false // 반투명 효과 끄기.
    }


}
