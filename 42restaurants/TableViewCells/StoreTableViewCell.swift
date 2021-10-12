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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = .white
        self.nameLabel.textColor = .black
        self.categoryLabel.textColor = .gray
        self.addressLabel.textColor = .black
        self.rateLabel.textColor = .gray
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
