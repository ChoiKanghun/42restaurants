//
//  FilterCollectionViewCell.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/23.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "filterCollectionViewCell"
    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var labelWrapperView: UIView!
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                setViewOnSelected()
            }
            else {
                self.configure(labelText: self.filterLabel?.text)
            }
        }
    }
    
    private func setViewOnSelected() {

        self.filterLabel.textColor = Config.shared.applicationOnSelectedTextColor
        self.labelWrapperView?.backgroundColor = Config.shared.applicationOnSelectedBackgroundColor
        self.filterLabel?.backgroundColor = Config.shared.applicationOnSelectedBackgroundColor
    }
    

 
    
    func configure(labelText: String?) {
        setLabelText(labelText: labelText)
        setUpView()
    }
    
    private func setLabelText(labelText: String?) {
        self.filterLabel?.text = labelText
    }
    
    private func setUpView() {
        setCellBackgroundColor()
        setLabelWrapperView()
        setLabelView()
    }

    private func setCellBackgroundColor() {
        self.labelWrapperView?.backgroundColor = Config.shared.applicationBackgroundLightGrayColor
        self.filterLabel?.backgroundColor = Config.shared.applicationBackgroundLightGrayColor
    }
    
    private func setLabelView() {
        self.filterLabel?.textAlignment = .center
        self.filterLabel?.textColor = .gray
        self.filterLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
    }
    
    private func setLabelWrapperView() {
        self.labelWrapperView?.layer.cornerRadius = 17 // frame.height / 3

    }
    
    
    
}
