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
    
    @IBOutlet weak var reviewImageHeight: NSLayoutConstraint!
    
    let storageRef = Storage.storage().reference()

    var images = [Image]()
    
    override func prepareForReuse() {
        self.reviewImageView.sd_cancelCurrentImageLoad()
        
        self.reviewImageView.image = nil
    }
    
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
        
        
    }
    
    func setImage() {
        self.reviewImageHeight?.isActive = true
        if self.images.count == 0 {
            print("image height 0 in")
            self.reviewImageHeight?.constant = 0
            
        } else {
            self.reviewImageHeight?.constant = 200

        }
        
        if let image = self.images.first {
            let reference = self.storageRef.child("\(image.imageUrl)")
            self.reviewImageView.sd_setImage(with: reference)
            
        } else {
            
        }
        
    }
    
    
}


