//
//  ReviewTableViewCell.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/08/10.
//

import UIKit
import Firebase

class ReviewTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "reviewTableViewCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var starImageView: UIImageView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!

    let storage = Storage.storage()
    
    private var _images = [Image]()
    var images: [Image] = [] {

        didSet (newVal) {
            _images = newVal
            self.collectionView.reloadData()
            
        }
    }
    
    override func awakeFromNib() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        setUI()
    }
    
    private func setUI() {
        if self.images.count < 1 {
            self.collectionViewHeight.constant = 0
        } else {
            self.collectionViewHeight.constant = 200
        }
        
        self.collectionView.backgroundColor = Config.shared.application60Color
        self.backgroundColor = Config.shared.application60Color
        self.userIdLabel.textColor = Config.shared.applicationContrastTextColor
        self.ratingLabel.textColor = Config.shared.applicationSupplimetaryTextColor
        self.descriptionLabel.textColor = Config.shared.applicationContrastTextColor
        
    }
    
    
}

extension ReviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: ReviewImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ReviewImageCollectionViewCell
        else { return UICollectionViewCell() }
        
        let storageRef = self.storage.reference()


        DispatchQueue.main.async {
            if let index: IndexPath = collectionView.indexPath(for: cell) {
                
                if index.row == indexPath.row {
                    let image = self.images[indexPath.row]
                    
                    
                    let reference = storageRef.child("\(image.imageUrl)")
                    
                    cell.imageView.sd_setImage(with: reference, placeholderImage: UIImage(named: "placeholder.jpg"))
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ReviewImageCollectionViewCell,
              let cellImage = cell.imageView.image
        else { print("can't find any image");return }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let enlargedImageViewController = storyBoard.instantiateViewController(withIdentifier: "EnlargedImageViewController")
                as? EnlargedImageViewController
        else { return }
        
        enlargedImageViewController.imagePassed = cellImage
        self.window?.rootViewController?.present(enlargedImageViewController, animated: true, completion: nil)
    }
  
    
}

extension ReviewTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.images.count == 1 {
            return CGSize(width: UIScreen.main.bounds.size.width - 50, height: 200)
        } else {
            return CGSize(width: 200, height: 200)
        }
    }
}
