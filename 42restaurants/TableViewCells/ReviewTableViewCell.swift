//
//  ReviewTableViewCell.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/08/10.
//

import UIKit
import FirebaseStorage
import FirebaseUI

class ReviewTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "reviewTableViewCell"
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var starImageView: UIImageView!
    
    @IBOutlet weak var reviewImageView: UIImageView!
    
    let storageRef = Storage.storage().reference()

    var images = [Image]()
    
    override func awakeFromNib() {
        setUI()
    }
    
    private func setUI() {
        self.backgroundColor = Config.shared.application60Color
        self.userIdLabel.textColor = Config.shared.applicationContrastTextColor
        self.ratingLabel.textColor = Config.shared.applicationSupplimetaryTextColor
        self.descriptionLabel.textColor = Config.shared.applicationContrastTextColor
    }
    
    func setUserIdLabelText(userId: String) {
        self.userIdLabel.text = userId
    }
    
    func setDescriptionLabelText(description: String) {
        self.descriptionLabel.text = description
    }
    
    func setRatingLabelText(rating: Double) {
        self.ratingLabel.text = "\(rating)"
        
        setImage()
    }
    
    func setImage() {
        if let image = self.images.first {
            let reference = self.storageRef.child("\(image.imageUrl)")
            self.reviewImageView.sd_setImage(with: reference)
            NSLayoutConstraint.activate([
                self.reviewImageView.heightAnchor.constraint(equalToConstant: 200)
            ])
        } else {
            NSLayoutConstraint.activate([
                self.reviewImageView.heightAnchor.constraint(equalToConstant: 0)
            ])
        }
        
    }
    
    
}


