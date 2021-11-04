//
//  ModifyMyReviewViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/11/04.
//

import UIKit
import Firebase
import CodableFirebase
import Photos
import YPImagePicker

class ModifyMyReviewViewController: UIViewController {
    static let storyboardId: String = "modifyMyReviewViewController"
    
    var commentKey: String?
    var commentPath: String?
    var images: [(String, Image)] = []
    var imageSet = [UIImage]()
    
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
        
    }
    
    private func setCollectionViewValues() {
        setCommentPathAndImages()
    }
    
    private func setCommentPathAndImages() {
        guard let commentKey = self.commentKey
        else { print("can't get commentKey"); return }
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
                                // 이미지 있는 경우
                                if let commentImagePairs = comment.value.images {
                                    for commentImagePair in commentImagePairs {
                                        self.images.append((commentImagePair.key, commentImagePair.value))
                                        
                                    }
                                    DispatchQueue.main.async {
                                        self.setTextView(comment.value.description)
                                        self.setRating(comment.value.rating)
                                        self.imageCollectionView.reloadData()
                                        return
                                    }
                                    return
                                }
                                else { // 이미지 없는 경우
                                    DispatchQueue.main.async {
                                        self.setTextView(comment.value.description)
                                        self.setRating(comment.value.rating)
                                    }
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
    
    private func setTextView(_ description: String) {
        self.descriptionTextView.text = description
    }
    
    private func setRating(_ rating: Double) {
        let formattedRating =  Double(floor(rating * 10)) / 10
        self.ratingLabel.text = String(formattedRating)
        self.starRatingSlider.value = Float(formattedRating)
        
        let floatValue = Float(floor(rating * 10)) / 10
        
        for index in 1...5 {
            if let starImage = view.viewWithTag(index) as? UIImageView {
                if Float(index) <= floatValue {
                    starImage.image = UIImage(named: "star_full_48px")
                } else if Float(index) - floatValue <= 0.5 {
                    starImage.image = UIImage(named: "star_half_48px")
                } else {
                    starImage.image = UIImage(named: "star_empty_48px")
                }
            }
        }
    }
    
    private func setUI() {
        self.addImageButton.alpha = 0.0
    }
    
    @IBAction func onDragStarSlider(_ sender: UISlider) {
        let floatValue = floor(sender.value * 10) / 10
        
        for index in 1...5 {
            if let starImage = view.viewWithTag(index) as? UIImageView {
                if Float(index) <= floatValue {
                    starImage.image = UIImage(named: "star_full_48px")
                } else if Float(index) - floatValue <= 0.5 {
                    starImage.image = UIImage(named: "star_half_48px")
                } else {
                    starImage.image = UIImage(named: "star_empty_48px")
                }
            }
        }
        DispatchQueue.main.async { self.ratingLabel?.text = "\(floatValue)" }
    }
    
    @IBAction func touchUpAddImageButton(_ sender: Any) {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 10
        config.library.mediaType = .photo
        config.startOnScreen = .library
        let picker = YPImagePicker(configuration: config)
        
        self.present(picker, animated: true, completion: nil)
        
        var temporaryImageSet = [UIImage]()
        
        picker.didFinishPicking(completion: { [unowned picker] items, cancelled in
            if cancelled == true { print("picking image cancelled")}
            else {
                for item in items {
                    switch item {
                    case .photo(let photo):
                        temporaryImageSet.append(photo.image)
                    default:
                        self.showBasicAlert(title: "타입 불일치", message: "이미지만 올려주세요")
                        picker.dismiss(animated: true, completion: nil)
                        return
                    }
                }
                self.imageSet = temporaryImageSet
            }
            picker.dismiss(animated: true, completion: nil)
            DispatchQueue.main.async { self.imageCollectionView.reloadData() }
        })
        
    }
    
    @IBAction func touchUpModifyingButton(_ sender: Any) {
        if self.modifyingButton.title == "수정하기" { changeUIOnModifying(); return }
        else { LoadingService.showLoading(); modifyReview() }
        
    }
    
    private func changeUIOnModifying() {
        self.addImageButton.alpha = 1.0
        self.modifyingButton.title = "저장하기"
        self.descriptionTextView.isUserInteractionEnabled = true
    }
    
    private func modifyReview() {
        // MARK: 1. 필수 항목이 비어있으면 오류 처리
        if self.descriptionTextView.text == "" {
            LoadingService.hideLoading()
            self.showBasicAlert(title: "내용을 입력하세요.", message: "내용은 필수 값입니다.")
            return
        }
        
        // MARK: 2. description과 commentKey, rating 추출
        guard let description = self.descriptionTextView.text,
              let commentKey = self.commentKey
        else { print("can't get description/commentKey"); return }
        let rating = self.starRatingSlider.value
        
        // MARK: 3. 이미지 변경사항이 있다면 이미지부터 업로드.
        
        
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
