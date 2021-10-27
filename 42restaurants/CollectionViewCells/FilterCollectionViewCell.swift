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
        self.filterLabel?.textColor = .systemGray2
        self.filterLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
    }
    
    private func setLabelWrapperView() {
        self.labelWrapperView?.layer.cornerRadius = 17 // frame.height / 3

    }
    
    func onSelected() {
        sendFilterNotification()
        self.filterLabel.textColor = Config.shared.applicationOnSelectedTextColor
        self.labelWrapperView?.backgroundColor = Config.shared.applicationOnSelectedBackgroundColor
        self.filterLabel?.backgroundColor = Config.shared.applicationOnSelectedBackgroundColor
        self.isSelected = true
    }
    
    private func sendFilterNotification() {
        if let filter = self.filterLabel.text {
            NotificationCenter.default.post(name: Notification.Name("filterSelected"),
                                            object: nil,
                                            userInfo: ["filter": filter])
        }
        
    }
    
    func onDeselected(){
        self.setUpView()
        self.isSelected = false
    }
    
}
