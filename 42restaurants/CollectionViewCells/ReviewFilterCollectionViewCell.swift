//
//  ReviewFilterCollectionViewCell.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/28.
//

import UIKit

class ReviewFilterCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier: String = "reviewFilterCollectionViewCell"
    
    @IBOutlet weak var reviewFilterLabel: UILabel!
    @IBOutlet weak var labelWrapperView: UIView!
    
    func configure(labelText: String?) {
        setLabelText(labelText: labelText)
        setUpView()
    }
    
    private func setLabelText(labelText: String?) {
        self.reviewFilterLabel?.text = labelText
    }
    
    private func setUpView() {
        setCellBackgroundColor()
        setLabelWrapperView()
        setLabelView()
    }

    private func setCellBackgroundColor() {
        self.labelWrapperView?.backgroundColor = Config.shared.applicationBackgroundLightGrayColor
        self.reviewFilterLabel?.backgroundColor = Config.shared.applicationBackgroundLightGrayColor
    }
    
    private func setLabelView() {
        self.reviewFilterLabel?.textAlignment = .center
        self.reviewFilterLabel?.textColor = .systemGray2
        self.reviewFilterLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
    }
    
    private func setLabelWrapperView() {
        self.labelWrapperView?.layer.cornerRadius = 17 // frame.height / 3

    }
    
    func onSelected() {
        sendFilterNotification()
        self.reviewFilterLabel.textColor = Config.shared.applicationOnSelectedTextColor
        self.labelWrapperView?.backgroundColor = Config.shared.applicationOnSelectedBackgroundColor
        self.reviewFilterLabel?.backgroundColor = Config.shared.applicationOnSelectedBackgroundColor
        self.isSelected = true
    }
    
    private func sendFilterNotification() {
        if let reviewFilter = self.reviewFilterLabel.text {
            NotificationCenter.default.post(name: Notification.Name("reviewFilterSelected"),
                                            object: nil,
                                            userInfo: ["reviewFilter": reviewFilter])
        }
    }
    
    func onDeselected(){
        self.setUpView()
        self.isSelected = false
    }
        


}
