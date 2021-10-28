//
//  FilterCollectionViewFlowLayout.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/25.
//

import UIKit

class FilterCollectionViewFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 20.0
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 10
        self.minimumInteritemSpacing = 10.0
        self.sectionInset = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 50.0)
    
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
    
}
