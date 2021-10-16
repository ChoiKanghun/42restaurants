//
//  UICollectionView+Extensions.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/15.
//

import Foundation
import UIKit

extension UICollectionView {
    func getCellSize(numberOFItemsRowAt: Int) -> CGSize {
        var screenWidth = UIScreen.main.bounds.width
        var screenHeight = UIScreen.main.bounds.height
        
        let window = UIApplication.shared.keyWindow
        let leftPadding = window?.safeAreaInsets.left ?? 0
        let rightPadding = window?.safeAreaInsets.right ?? 0
        let topPadding = window?.safeAreaInsets.top ?? 0
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        screenWidth -= (leftPadding + rightPadding)
        screenHeight -= (topPadding + bottomPadding)
        
        let cellWidth =  screenWidth / CGFloat(numberOFItemsRowAt)
        
        return CGSize(width: cellWidth, height: screenHeight)
    }
}
