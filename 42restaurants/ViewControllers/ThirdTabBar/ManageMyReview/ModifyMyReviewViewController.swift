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
    var storeKey: String?
    var imagesBeforeChanged: [(String, Image)] = []
    var imageSet = [UIImage]()
    var imagePaths = [String]()
    var isImageChanged: Bool = false
    var mainImageValue: String?
    
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
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapVoidArea)))
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
    
    @objc func onTapVoidArea() {
        view.endEditing(true)
    }
    
    private func setDefaultValues() {
        LoadingService.showShortLoading()
        self.descriptionTextView.isUserInteractionEnabled = false
        self.starRatingSlider.isUserInteractionEnabled = false
        
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
                self.imagesBeforeChanged = []
                guard let value = snapshot.value else { return }
                do {
                    let storesData = try FirebaseDecoder().decode([String : StoreInfo].self, from: value)
                    for storeData in storesData {
                        let comments = storeData.value.comments
                        for comment in comments {
                            if comment.key == commentKey {
                                self.storeKey = storeData.key
                                self.mainImageValue = storeData.value.mainImage
                                // 이미지 있는 경우
                                if let commentImagePairs = comment.value.images {
                                    for commentImagePair in commentImagePairs {
                                        self.imagesBeforeChanged.append(
                                            (commentImagePair.key, commentImagePair.value))
                                        
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
        
        self.imageSet = [];
        self.isImageChanged = true
        var temporaryImageSet = [UIImage]()
        picker.didFinishPicking(completion: { [unowned picker] items, cancelled in
            if cancelled == true {
                picker.dismiss(animated: false, completion: nil)
                self.navigationController?.popViewController(animated: false)
                self.showBasicAlert(title: "이미지 선택 취소", message: "오류 방지를 위해 이전 화면으로 돌아갑니다.")
                return
            }
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
        self.starRatingSlider.isUserInteractionEnabled = true
    }
    
    private func modifyReview() {
        // MARK: 1. 필수 항목이 비어있으면 오류 처리
        if self.descriptionTextView.text == "" {
            LoadingService.hideLoading()
            self.showBasicAlert(title: "내용을 입력하세요.", message: "내용은 필수 값입니다.")
            return
        }
        
        // MARK: 2. description과 commentKey, storeKey, rating 추출
        guard let description = self.descriptionTextView.text,
              let commentKey = self.commentKey,
              let storeKey = self.storeKey
        else { print("can't get description/commentKey"); return }
        let rating = self.starRatingSlider.value
        
        // MARK: 3. 이미지 변경사항이 있다면 이미지부터 업로드.
        if self.imageSet.count != 0 {
            print("이미지 있는 걸로 들어옴")
            for (index, image) in self.imageSet.enumerated() {
                guard let uploadImageData = image.jpegData(compressionQuality: 0.8)
                else {
                    self.navigationController?.popViewController(animated: false)
                    self.showBasicAlert(title: "업로드 실패", message: "이미지 형식 확인해주세요.")
                    return
                }
                
                let data: Data = uploadImageData
                
                let filePath = "images/\(storeKey)/\(UUID().uuidString)\(Date().toString()).png"
                let metaData = StorageMetadata()
                metaData.contentType = "image/png"
                
                // 올리기 시작
                let uploadTask = self.storageRef.child(filePath).putData(data, metadata: metaData) {
                    [self] (metadata, error) in
                    
                    if let error = error {
                        self.navigationController?.popViewController(animated: false)
                        showBasicAlert(title: "업로드 실패", message: "인터넷 연결을 확인해주세요 !")
                        print(error.localizedDescription)
                        return
                    }
                    let imagePath = filePath
                    self.imagePaths.append(imagePath)
                }
                
                
                
                // 이미지를 모두 올렸다면 comment를 수정하기 시작.
                uploadTask.observe(.success) { snapshot in
                    let uploadPath = "stores/\(storeKey)/comments/\(commentKey)"
                    if index == self.imageSet.count - 1 {
                        self.ref.child(uploadPath).child("rating").setValue(rating)
                        self.ref.child(uploadPath).child("description").setValue(description) {
                            (error, reference: DatabaseReference) in
                            
                            if let error = error {
                                print(error.localizedDescription)
                                self.navigationController?.popViewController(animated: false)
                                self.showBasicAlert(title: "에러", message: "이미지 업로드 도중 에러 발생")
                            } else {
                                
                                var uploadImagePairs = Dictionary<String, Any>()
                                for i in 0..<self.imageSet.count {
                                    if let autoKey = self.ref.child(uploadPath).child("images").childByAutoId().key {
                                        let now = Date().toDouble()
                                        uploadImagePairs[autoKey] = [
                                            "createDate": now,
                                            "modifyDate": now,
                                            "imageUrl": self.imagePaths[i]
                                        ]
                                    }
                                }

                                self.ref.child(uploadPath).child("images").setValue(uploadImagePairs) {
                                    (error, ref) in
                                    if let error = error {
                                        self.showBasicAlert(title: "에러", message: "이미지 db 세팅 중 에러남.")
                                        print(error.localizedDescription)
                                    }
                                    for uploadImagePair in uploadImagePairs {
                                        self.ref.child("stores/\(storeKey)/images").child(uploadImagePair.key)
                                            .setValue(uploadImagePair.value)
                                    }
                                    if self.deleteImagesBeforeChanged() == true {
                                        self.navigationController?.popViewController(animated: false)
                                        self.showBasicAlert(title: "성공", message: "수정사항이 반영되었습니다.")
                                    } else {
                                        self.navigationController?.popViewController(animated: false)
                                        self.showBasicAlert(title: "실패", message: "기존 이미지 삭제처리중 에러")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else { // 이미지 없을 때
            if deleteImagesBeforeChanged() == false {
                self.navigationController?.popViewController(animated: false)
                self.showBasicAlert(title: "에러", message: "기존 이미지 삭제 불가.")
                return
            }
            self.ref.child("stores/\(storeKey)/comments/\(commentKey)").child("rating").setValue(rating)
            self.ref.child("stores/\(storeKey)/comments/\(commentKey)").child("description").setValue(description) {
                (error, ref) in
                if let error = error {
                    self.showBasicAlert(title: "에러", message: "이미지 없지만 rating, description 반영 실패")
                    print(error.localizedDescription)
                } else {
                    self.navigationController?.popViewController(animated: false)
                    self.showBasicAlert(title: "성공", message: "수정사항이 반영되었습니다.")
                }
                
            }
        }
    }
    
    private func deleteImagesBeforeChanged() -> Bool {
        if self.isImageChanged != true { return true }
        guard let storeKey = self.storeKey else { print("error while storekey"); return false}
        // 1 mainImage의 value와같은 값을 가지는 이미지 Key가 있다면
        // 즉, store 자체 image를 나타내는 첫 번째 리뷰의 경우
        
        guard let mainImageValue = self.mainImageValue
        else { print("error while mainImage"); return false}
        for imageBeforeChanged in self.imagesBeforeChanged {
            if mainImageValue == imageBeforeChanged.1.imageUrl {
                // 1.1 imageSet의 길이가 0이면 에러처리.
                if self.imageSet.count == 0 {
                    print("기존 이미지 삭제 불가한 리뷰입니다.")
                    return false
                } else { // 1.2 imagePaths의 첫 번째 요소를 MainImage로 등록.
                    guard let firstImagePath = self.imagePaths.first else { print("에러날리가.."); return false }
                    self.ref.child("stores/\(storeKey)").child("mainImage").setValue(firstImagePath)
                }
            }
            // 2. commentPath 밑의 기존 이미지삭제
            self.ref.child("stores/\(storeKey)/comments/images").child(imageBeforeChanged.0).removeValue()
            // 3. store 밑의 기존 이미지 삭제
            self.ref.child("stores/\(storeKey)/images").child(imageBeforeChanged.0).removeValue()
            // 4. 기존이미지 스토리지에서 삭제
            self.storageRef.child(imageBeforeChanged.1.imageUrl).delete { error in
                if let error = error { print("스토리지에서 삭제 에러: \(error.localizedDescription)")}
            }
            // 5. 성공 시 true 반환
        }
        return true
    }
}

extension ModifyMyReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.imagesBeforeChanged.count == 0 && self.imageSet.count == 0{
            DispatchQueue.main.async { collectionView.setHorizontalCollectionViewEmptyBackground() }
        } else {
            DispatchQueue.main.async { collectionView.resetBackground() }
        }
        if self.imageSet.count == 0 {
            return self.imagesBeforeChanged.count
        } else {
            return self.imageSet.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = self.imageCollectionView.dequeueReusableCell(
                withReuseIdentifier: ModifyReviewImageCollectionViewCell.reuseIdentifier, for: indexPath)
                as? ModifyReviewImageCollectionViewCell
        else { return UICollectionViewCell() }
        
        if self.imageSet.count == 0 {
            let imageUrl = self.imagesBeforeChanged[indexPath.row].1.imageUrl
            let reference = self.storageRef.child(imageUrl)
            cell.modifyReviewImageView.sd_setImage(with: reference)
        } else {
            cell.modifyReviewImageView.image = self.imageSet[indexPath.row]
        }
        return cell
    }
}

extension ModifyMyReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 150)
    }
}
