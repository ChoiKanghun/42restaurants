//
//  CommentPostViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/26.
//

import UIKit
import OpalImagePicker
import Photos
import Firebase

class CommentPostViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var starRatingSlider: UISlider!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var userIdTextField: UITextField!
    
    // 키보드 높이
    @IBOutlet weak var keyHeight: NSLayoutConstraint!
    
    let imagePicker = OpalImagePickerController()
    var imageSet = [UIImage]()
    let phImageManager = PHImageManager.default()
    let phImageOption = PHImageRequestOptions()
    
    var ref: DatabaseReference!
    let storage = Storage.storage()
    
    var localCommentImageUrls = [String: Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        
        initializeOpalImagePicker()
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if let userInfo:NSDictionary = sender.userInfo as NSDictionary?,
           let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            keyHeight.constant = keyboardHeight
        }
        

        
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        //우리가 지정한 constaraint
        keyHeight.constant = 10
    }
    
    private func initializeOpalImagePicker() {
        self.imagePicker.maximumSelectionsAllowed = 10
        let configuration = OpalImagePickerConfiguration()
        configuration.maximumSelectionsAllowedMessage
            = NSLocalizedString("최대 10장까지 선택 가능합니다.", comment: "")
        self.imagePicker.configuration = configuration

        // phImageOpation 세팅
        self.phImageOption.isSynchronous = true
    }

    @IBAction func touchUpAddImageButton(_ sender: Any) {
        
        self.imageSet = [UIImage]()
        
        presentOpalImagePickerController(
            imagePicker,
            animated: true,
            select: { (assets) in
                for asset in assets {
                    // 단점: scaleToFill 을 지원하지 않는다.
                    self.phImageManager.requestImage(
                        for: asset,
                        targetSize: CGSize(width: 100.0, height: 100.0),
                        contentMode: .default,
                        options: self.phImageOption,
                        resultHandler: { (result, info) in
                            if let result = result {
                                self.imageSet.append(result)
                            }
                        })
                }
//                self.imageSet = assets
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            },
            cancel: {
                self.imageSet = [UIImage]()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            })
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
        DispatchQueue.main.async {
            self.ratingLabel?.text = "\(floatValue)"
        }
    }
    
    @IBAction func touchUpSubmitButton(_ sender: UIBarButtonItem) {
        
        if let target = StoreSingleton.shared.store?.storeKey {
            // 현재 가게의 comments 대한 ref
            self.ref = Database.database(url: "https://restaurants-e62b0-default-rtdb.asia-southeast1.firebasedatabase.app/stores/\(target)").reference()
        } else { print(" 리뷰 남기기 실패 "); return }
        
        
        for (index, image) in imageSet.enumerated() {
            guard let uploadImageData = image.jpegData(compressionQuality: 0.8)
            else { print("error while converting image"); return }
            
            var data = Data()
            data = uploadImageData
            let filePath = "images/\(self.userIdTextField.text ?? "defaultUser")\(Date().toString()).png"
            let metaData = StorageMetadata()
            metaData.contentType = "image/png"
            
            self.storage.reference().child(filePath)
                .putData(data, metadata: metaData) { [self] (metadata, error) in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        self.showBasicAlert(title: "에러", message: "이미지 업로드 도중 에러 발생")
                        return
                    }
                    
//                    self.localCommentImageUrls["\(index + 1)"] = filePath
            }
            
            
            
        }

        // 현재 ref는 storeKey: storeInfo 형태.
        self.ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            
            if var uploadData = currentData.value as? StoreInfo,
               let userId = self.userIdTextField.text {
                let commentCount: Int = uploadData.comments.count
                var comments = uploadData.comments
//                comments["\(commentCount + 1)"] = Comment(
//                    rating: Double(floor(self.starRatingSlider.value * 10) / 10),
//                    description: self.descriptionTextView.text,
//                    userId: userId,
//                    images: )
                uploadData.comments = comments
                let storeImageCount = uploadData.images.count
                var storeImages = uploadData.images
                for (index, imageDict) in self.localCommentImageUrls.enumerated() {
                    storeImages["\(index + 1 + storeImageCount)"] = imageDict.value
                }
                uploadData.images = storeImages
                
                currentData.value = uploadData
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { error, committed, snapshot in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        
        
    }
    
    

}


extension CommentPostViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.imageSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoSetCollectionViewCell.reuseIdentifier,
                for: indexPath) as? PhotoSetCollectionViewCell
        else { return UICollectionViewCell() }
        cell.imageView.bounds = cell.bounds
        cell.imageView?.image = self.imageSet[indexPath.row]
        
        return cell
    }
    
    
}


extension CommentPostViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 100.0)
    }
    
}
