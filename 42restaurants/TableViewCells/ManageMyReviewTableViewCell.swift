//
//  ManageMyReviewTableViewCell.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/11/04.
//

import UIKit

class ManageMyReviewTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = "manageMyReviewTableViewCell"

    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var touchFreeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
