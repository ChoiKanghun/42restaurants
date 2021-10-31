//
//  ReviewImageCollectionViewCell.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/08/10.
//

import UIKit
import Firebase

class ReviewImageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "reviewImageCollectionViewCell"
    let storageRef = Storage.storage().reference()
    
    @IBOutlet weak var reviewImageView: UIImageView!
    
    override func prepareForReuse() {
        
//        self.reviewImageView.sd_cancelCurrentImageLoad()
//        self.reviewImageView.image = UIImage(named: "placeholder.jpg")
    }
    
}
