//
//  CommentPostViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/26.
//

import UIKit
import Photos
import Firebase
import CodableFirebase
import YPImagePicker

class CommentPostViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var starRatingSlider: UISlider!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var userEmailLabel : UILabel!
    
    // 키보드 높이
    @IBOutlet weak var keyHeight: NSLayoutConstraint!
    
    // 갤러리에서 이미지 선택 시 IMAGESET로 들어감
    var imageSet = [UIImage]()
    // imageSet에 담긴 image들은 upload 시 images에 담겼다가 올라감.
    var images = [String]()
    
    var ref: DatabaseReference!
    let storage = Storage.storage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnTouchAnywhere)))
        self.dismissIfNotLoggedIn()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    
        self.starRatingSlider.value = 5.0
        
        
        fillBasicInfo()
        handleKeyboardAppearance()
        self.ref = Database.database(url: "https://restaurants-e62b0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    }
    
    
    @objc func dismissKeyboardOnTouchAnywhere() {
        view.endEditing(true)
    }
    
    private func fillBasicInfo() { // 추후 길어질 수도 있으므로 함수로 빼둠.
        self.userEmailLabel.text = FirebaseAuthentication.shared.getUserEmail()
    }
    
    private func handleKeyboardAppearance() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    


    @IBAction func touchUpAddImageButton(_ sender: Any) {
        
        // config는 사진 옵션 선택
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 10
        config.library.mediaType = .photo
        config.startOnScreen = .library
        let picker = YPImagePicker(configuration: config)
        
        // 먼저 Picker를 Present 해야 한다.
        present(picker, animated: true, completion: nil)

        var temporaryImageSet = [UIImage]()
        // 사용자가 사진 Picking을 끝냈다면
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled == true { // cancel 시
                print("picker has been cancelled")
            }
            else {
                for item in items {
                    switch item {
                    case .photo(let photo):
                        print(type(of: photo))
                        temporaryImageSet.append(photo.image)
                    default: // 고른 사진의 타입이 이상하면 에러처리.
                        self.showBasicAlert(title: "타입 불일치", message: "이미지만 올려주세요")
                        picker.dismiss(animated: true, completion: nil)
                        return
                    }
                }
                self.imageSet = temporaryImageSet
            }
            picker.dismiss(animated: true, completion: nil)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

        
        
    }
    //                 DispatchQueue.main.async {
 //   self.collectionView.reloadData()
// }
    
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
        LoadingService.showLoading()
        // MARK: 1. 필수 항목 비어 있으면 오류 처리하기.
        if self.descriptionTextView.text == "" {
            LoadingService.hideLoading()
            self.showBasicAlert(title: "내용을 입력하세요.", message: "내용은 필수 입력값입니다.");
            return
        }
        
        // MARK: 2. userId와 description 추출
        guard let userId = self.userEmailLabel.text,
              let description = self.descriptionTextView.text
        else { print("no user id error"); return }
        

        
        // MARK: 3. 이미지가 있다면 이미지를 먼저 업로드.
        
        guard let tabBarIndex = self.tabBarController?.selectedIndex,
              let storeKey = tabBarIndex == 0 ? MainTabStoreSingleton.shared.store?.storeKey
                : StoreSingleton.shared.store?.storeKey
        else { fatalError("인터넷 연결 확인 필요") }
    
        
        if self.imageSet.count != 0 {
            
            for (index, image) in self.imageSet.enumerated() {
                guard let uploadImageData = image.jpegData(compressionQuality: 0.8)
                else {
                    LoadingService.hideLoading()
                    self.showBasicAlert(title: "업로드 실패", message: "인터넷 연결 또는 이미지 형식을 확인해주세요");
                    return
                }
                
                var data = Data()
                data = uploadImageData
                let filePath = "images/\(storeKey)/\(UUID().uuidString)\(Date().toString()).png"
                let metaData = StorageMetadata()
                metaData.contentType = "image/png"
                
                // 올리기 시작
                let uploadTask =
                    self.storage.reference().child("\(filePath)").putData(data, metadata: metaData) {
                        [self] (metadata, error) in
                        
                        if let error = error {
                            print(error.localizedDescription)
                            LoadingService.hideLoading()
                            showBasicAlert(title: "이미지 업로드 실패", message: "인터넷 연결을 확인하세요")
                            return
                        }
                    }
                
                let image = filePath
                self.images.append(image)


                
                uploadTask.observe(.success) { snapshot in
                
                    if index == self.imageSet.count - 1 {
                        // MARK: 4. 이미지를 모두 storage에 올렸다면 comment올리기 시작.
                        
                        guard let newCommentKey = self.ref.child("stores/\(storeKey)/comments").childByAutoId().key
                        else {
                            LoadingService.hideLoading()
                            print("can't get childByAutoId comment");
                            return
                        }
                        
                        self.ref.child("stores/\(storeKey)/comments/\(newCommentKey)").setValue (
                            ["rating": Double(floor(self.starRatingSlider.value * 10) / 10),
                             "description": description,
                             "userId": userId,
                             "createDate": Date().toDouble(),
                             "modifyDate": Date().toDouble()
                            ]
                        ) {
                            (error: Error?, ref: DatabaseReference) in
                            if let error = error {
                                LoadingService.hideLoading()
                                print("flag1")
                                print(error.localizedDescription)
                            } else {
                                // MARK: 5. comment 후 comment 밑에 images 정보 등록.
                                var uploadImages = Dictionary<String, Any>()
                                for image in self.images {
                                    if let autoKey: String = ref.child("images").childByAutoId().key {
                                        
                                        uploadImages[autoKey] = [
                                            "createDate": Date().toDouble(),
                                            "modifyDate": Date().toDouble(),
                                            "imageUrl": image
                                        ]
                                    }
                                }
                                ref.child("images").setValue(uploadImages) {
                                    (error: Error?, ref: DatabaseReference) in
                                    if let error = error {
                                        print("flag2")
                                        LoadingService.hideLoading()
                                        print(error.localizedDescription)
                                    }
                                }
                                
                                // MARK: 6. 해당 store/images 정보 등록.
                                uploadImages = Dictionary<String, String>()
                                
                                let storeImageRef = self.ref.child("stores/\(storeKey)/images")
                                
                                for image in self.images {
                                    if let autoKey: String = storeImageRef.childByAutoId().key {
                                        uploadImages[autoKey] = [
                                            "createDate": Date().toDouble(),
                                            "modifyDate": Date().toDouble(),
                                            "imageUrl": image
                                        ]
                                    }
                                }
                               
                                
                                // 이전의 데이터 + 현재 데이터를 post해야 하므로.
                                // runTransactionalBlock을 씀.
                                self.ref.child("stores/\(storeKey)/images").runTransactionBlock ({ (currentData: MutableData) -> TransactionResult in
                                    
                                    if var post = currentData.value as? [String: Any] {
                                        for (key, value) in uploadImages {
                                            post[key] = value
                                        }
                                        currentData.value = post
                                        LoadingService.hideLoading()

                                        return TransactionResult.success(withValue: currentData)
                                    }
                                        LoadingService.hideLoading()
                                        return TransactionResult.success(withValue: currentData)
                                    
                                    })
                                }
                            }
                        }
                        
                    }
                    
                }
        } else { // if there's no image
            guard let newCommentKey = self.ref.child("stores/\(storeKey)/comments").childByAutoId().key
            else {
                LoadingService.hideLoading();
                print("can't get childByAutoId comment");
                return
            }
            
            self.ref.child("stores/\(storeKey)/comments/\(newCommentKey)").setValue (
                ["rating": Double(floor(self.starRatingSlider.value * 10)) / 10,
                 "description": description,
                 "userId": userId,
                 "createDate": Date().toDouble(),
                 "modifyDate": Date().toDouble()
                ]
            )
        }
        
        DispatchQueue.main.async {
            if self.imageSet.count != 0 {
                self.ref.child("stores").child("\(storeKey)").observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.exists() {
                        guard let value = snapshot.value else { return }
                        do {
                            let storeData = try FirebaseDecoder().decode(StoreInfo.self, from: value)
                            let commentCount = storeData.comments.count + 1
                            print("commentCount: \(commentCount)")
                            var sumOfRatings: Double = 0
                            for comment in storeData.comments {
                                sumOfRatings += comment.value.rating
                            }
                            let rating = Double(floor((sumOfRatings / Double(commentCount)) * 10)) / 10

                            self.ref.child("stores/\(storeKey)/rating").setValue(rating)
                            self.ref.child("stores/\(storeKey)/commentCount").setValue(commentCount)
                            LoadingService.hideLoading()
                            self.navigationController?.popViewController(animated: true)
                            NotificationCenter.default.post(name: Notification.Name("reviewSubmitDone"), object: nil)
                       } catch let err {
                            LoadingService.hideLoading()
                            print(err.localizedDescription)
                       }
                   }
                })
            } else {
                self.ref.child("stores").child("\(storeKey)").observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.exists() {
                        guard let value = snapshot.value else { return }
                        do {
                            let storeData = try FirebaseDecoder().decode(StoreInfo.self, from: value)
                            let commentCount = storeData.comments.count
                            print("commentCount: \(commentCount)")
                            var sumOfRatings: Double = 0
                            for comment in storeData.comments {
                                sumOfRatings += comment.value.rating
                            }
                            let rating = Double(floor((sumOfRatings / Double(commentCount)) * 10)) / 10

                            self.ref.child("stores/\(storeKey)/rating").setValue(rating)
                            self.ref.child("stores/\(storeKey)/commentCount").setValue(commentCount)
                            LoadingService.hideLoading()
                            self.navigationController?.popViewController(animated: true)
                            NotificationCenter.default.post(name: Notification.Name("reviewSubmitDone"), object: nil)
                       } catch let err {
                            LoadingService.hideLoading()
                            print(err.localizedDescription)
                       }
                   }
                })
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
