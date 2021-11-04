//
//  MyStoreTableViewCell.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/11/02.
//

import UIKit
import FirebaseUI
import FirebaseStorage

class MyStoreTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = "myStoreTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    
    let storageRef = Storage.storage().reference()
    
    
    var store: Store? {
        didSet {
            self.titleLabel?.text = store?.storeInfo.name
            self.addressLabel?.text = store?.storeInfo.address
            self.createDateLabel?.text = "등록일: " + getFormattedDate(date: store?.storeInfo.createDate)
            setImage(imageUrl: store?.storeInfo.mainImage)
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let imageHeightConstraint = self.storeImageView.heightConstraint {
            self.storeImageView.layer.cornerRadius = imageHeightConstraint.constant / 2.5
        }
        
    }
    
    private func getFormattedDate(date: Double?) -> String {
        guard let date = date else { return "" }
        let createDate = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let convertedString = dateFormatter.string(from: createDate)
        
        return convertedString
    }
    
    
    private func setImage(imageUrl: String?) {
        guard let imageUrl = imageUrl else { return }
        let reference = self.storageRef.child(imageUrl)
        self.storeImageView.sd_setImage(with: reference)
    }
    
    
}

