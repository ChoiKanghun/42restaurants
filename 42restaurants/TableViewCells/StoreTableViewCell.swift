//
//  StoreTableViewCell.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/24.
//

import UIKit

class StoreTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "StoreTableViewCellReuseIdentifier"
    
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    var store: Store? {
        didSet {
            if let store = store {
                self.setNameLabel(text: store.storeInfo.name)
                self.setAddressLabel(text: store.storeInfo.address ?? "")
                self.setCategoryLabel(text: store.storeInfo.category)
                self.setRateLabel(text: "\(store.storeInfo.rating)(\(store.storeInfo.commentCount))")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = .white
        self.nameLabel.textColor = .black
        self.categoryLabel.textColor = .gray
        self.addressLabel.textColor = .black
        self.rateLabel.textColor = .gray
        self.storeImageView.layer.cornerRadius = 90 / 3 // imageHeight / 3
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setNameLabel(text: String) {
        self.nameLabel?.text = text
    }
    func setAddressLabel(text: String) {
        self.addressLabel?.text = text
    }
    func setCategoryLabel(text: String) {
        self.categoryLabel?.text = text
    }
    func setRateLabel(text: String) {
        self.rateLabel?.text = text
    }
    
}
