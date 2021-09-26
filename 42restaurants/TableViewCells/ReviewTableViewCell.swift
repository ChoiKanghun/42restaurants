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
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var toRightImageView: UIImageView!
    
    let storage = Storage.storage()
    
    private var _images = [Image]()
    var images: [Image] {
        get {
            return _images
        }
        set (newVal) {
            _images = newVal
            DispatchQueue.main.async {
                if self._images.count == 0 {
                    self.collectionViewHeight.constant = 0
                    self.toRightImageView.isHidden = true
                } else {
                    self.collectionViewHeight.constant = 200
                    if self._images.count > 1 {
                        self.toRightImageView.isHidden = false
                    } else {
                        self.toRightImageView.isHidden = true
                    }
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets.trailing = 10
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            section.orthogonalScrollingBehavior = .paging
            
            return section
        }
    }
    
}

extension ReviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: ReviewImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ReviewImageCollectionViewCell
        else { return UICollectionViewCell() }

        let image = self.images[indexPath.row]
        
        let storageRef = storage.reference()
        let reference = storageRef.child("\(image.imageUrl)")
        cell.imageView.sd_setImage(with: reference, placeholderImage: UIImage(named: "placeholder.jpg"))
        return cell
    }
    
}

