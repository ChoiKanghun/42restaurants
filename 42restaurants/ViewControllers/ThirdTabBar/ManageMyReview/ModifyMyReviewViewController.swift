//
//  ModifyMyReviewViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/11/04.
//

import UIKit
import Firebase
import CodableFirebase

class ModifyMyReviewViewController: UIViewController {
    static let storyboardId: String = "modifyMyReviewViewController"
    
    var commentKey: String?
    var commentPath: String?
    var images: [(String, Image)] = []
    var ref: DatabaseReference!
    var storageRef = Storage.storage().reference()
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var starRatingSlider: UISlider!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var modifyingButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        
        self.ref = Database.database(url: "https://restaurants-e62b0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        setDefaultValues()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarHidden(isHidden: false)
        setUI()
    }
    
    private func setDefaultValues() {
        LoadingService.showShortLoading()
        self.descriptionTextView.isUserInteractionEnabled = false
        setCollectionViewValues()
        setTextView()
        setRating()
    }
    
    private func setCollectionViewValues() {
        setCommentPathAndImages()
    }
    
    private func setCommentPathAndImages() {
        guard let commentKey = self.commentKey else { return }
        self.ref.child("stores").getData(completion: { error, snapshot in
            if snapshot.exists() {
                self.images = []
                guard let value = snapshot.value else { return }
                do {
                    let storesData = try FirebaseDecoder().decode([String : StoreInfo].self, from: value)
                    for storeData in storesData {
                        let comments = storeData.value.comments
                        for comment in comments {
                            if comment.key == commentKey {
                                self.commentPath = "stores/\(storeData.key)/comments/\(commentKey)"
                                if let commentImagePairs = comment.value.images {
                                    for commentImagePair in commentImagePairs {
                                        self.images.append((commentImagePair.key, commentImagePair.value))
                                    }
                                    DispatchQueue.main.async {
                                        self.imageCollectionView.reloadData()
                                        return
                                    }
                                    return
                                }
                            }
                        }
                    }
                } catch let e {
                    print(e.localizedDescription)
                }
            }
        })
    }
    
    private func setTextView() {
        guard let commentPath = self.commentPath else { return }
        self.ref.child(commentPath).child("description").getData(completion: { error, snapshot in
            if snapshot.exists() {
                guard let description = snapshot.value as? String else { print("can't get value"); return }
                self.descriptionTextView.text = description
            }
        })
    }
    
    private func setRating() {
        guard let commentPath = self.commentPath else { return }
        self.ref.child(commentPath).child("rating").getData(completion: { error, snapshot in
            if snapshot.exists() {
                guard let rating = snapshot.value as? Double else { print("can't get value"); return }
                let formattedRating =  Double(floor(rating * 10)) / 10
                self.ratingLabel.text = String(formattedRating)
                self.starRatingSlider.value = Float(formattedRating)
            }
        })
    }
    
    private func setUI() {
        self.addImageButton.alpha = 0.0
    }
    
    @IBAction func touchUpModifyingButton(_ sender: Any) {
        if self.modifyingButton.title == "수정하기" { changeUIOnModifying() }
    }
    
    private func changeUIOnModifying() {
        self.addImageButton.alpha = 1.0
        self.modifyingButton.title = "저장하기"
        self.descriptionTextView.isUserInteractionEnabled = true
    }
    
    


}

extension ModifyMyReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.images.count == 0 {
            DispatchQueue.main.async { collectionView.setHorizontalCollectionViewEmptyBackground() }
        } else {
            DispatchQueue.main.async { collectionView.resetBackground() }
        }
        
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = self.imageCollectionView.dequeueReusableCell(
                withReuseIdentifier: ModifyReviewImageCollectionViewCell.reuseIdentifier, for: indexPath)
                as? ModifyReviewImageCollectionViewCell
        else { return UICollectionViewCell() }
        
        let imageUrl = self.images[indexPath.row].1.imageUrl
        let reference = self.storageRef.child(imageUrl)
        cell.modifyReviewImageView.sd_setImage(with: reference)
        
        return cell
    }
}

extension ModifyMyReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 150)
    }
}
