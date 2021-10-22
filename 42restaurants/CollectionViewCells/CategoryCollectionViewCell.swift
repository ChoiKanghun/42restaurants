//
//  CategoryCollectionViewCell.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/22.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifer: String = "categoryCollectionViewCellReuseIdentifier"
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                self.categoryLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
                self.categoryLabel.textColor = Config.shared.applicationFontDefaultColor
//                fitCellSizeToLabelSize()
                
                
            } else {
                self.categoryLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
                self.categoryLabel.textColor = Config.shared.applicationFontLightColor
                
//                fitCellSizeToLabelSize()
            }
        }
    }
    

    func setCategoryCollectionViewCellUI() {
        self.categoryLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        self.categoryLabel.textColor = Config.shared.applicationFontLightColor
    }
    
//    func fitCellSizeToLabelSize() -> CGSize {
////        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width + 5, height: self.bounds.height)
//        let targetSize = CGSize(width:  self.categoryLabel.bounds.width + 50, height: self.categoryLabel.bounds.height + 1)
//        return self.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
//
//    }
    


//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        setNeedsLayout()
//        layoutIfNeeded()
//        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//        var newFrame = layoutAttributes.frame
//        newFrame.size.width = CGFloat(ceilf(Float(size.width)))
//        layoutAttributes.frame = newFrame
//
//        return layoutAttributes
//    }
    
    func setCellLabelText(_ text: String) {
        self.categoryLabel.text = text
    }
    

}
