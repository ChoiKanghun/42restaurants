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
                
                
            } else {
                self.categoryLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
                self.categoryLabel.textColor = Config.shared.applicationFontLightColor
                
            }
        }
    }
    

    func setCategoryCollectionViewCellUI() {
        self.categoryLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        self.categoryLabel.textColor = Config.shared.applicationFontLightColor
    }
    

    
    func setCellLabelText(_ text: String) {
        self.categoryLabel.text = text
    }
    

}
