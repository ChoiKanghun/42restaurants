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
    
    @IBOutlet weak var reviewImagesCollectionView: UICollectionView!
    @IBOutlet weak var reviewImagesCollectionViewHeight: NSLayoutConstraint!

    let storageRef = Storage.storage().reference()

    var images = [Image]()
    
    override func prepareForReuse() {
//        for i in 0..<self.images.count {
//            if let cell = self.reviewImagesCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? ReviewImageCollectionViewCell {
//                cell.reviewImageView.sd_cancelCurrentImageLoad()
//                cell.reviewImageView.image = nil
//            }
//        }
//        self.reviewImagesCollectionView.reloadData()
    }
    
    override func awakeFromNib() {
        self.reviewImagesCollectionView.delegate = self
        self.reviewImagesCollectionView.dataSource = self
        
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
        
        self.reviewImagesCollectionViewHeight?.isActive = true
        self.reviewImagesCollectionViewHeight?.constant = self.images.isEmpty == true ? 0.0 : 150.0
        self.reviewImagesCollectionView.reloadData()
        
    }
    
    
}

extension ReviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.reviewImagesCollectionView.dequeueReusableCell(withReuseIdentifier: ReviewImageCollectionViewCell.reuseIdentifier, for: indexPath)
        as? ReviewImageCollectionViewCell
        else { print("can't getReviewImageCollectionViewCell"); return UICollectionViewCell() }

        
        let image = self.images[indexPath.row]
        let reference = self.storageRef.child(image.imageUrl)
        cell.reviewImageView.sd_setImage(with: reference)
        cell.reviewImageView.contentMode = .scaleAspectFit
        self.reviewImagesCollectionView.reloadItems(at: [indexPath])
        
        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Name("showEnlargedImage"),
                                        object: nil,
                                        userInfo: ["imageUrl": self.images[indexPath.row].imageUrl])
    }
    
}

extension ReviewTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = self.reviewImagesCollectionView.frame.size.width
        if self.images.count == 1 {
            return CGSize(width: screenWidth, height: 150)
        } else {
            return CGSize(width: screenWidth / 2, height: 150)
        }
    }
}


