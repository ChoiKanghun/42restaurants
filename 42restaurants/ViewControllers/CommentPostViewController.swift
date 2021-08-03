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
    var images = [String]()
    let phImageManager = PHImageManager.default()
    let phImageOption = PHImageRequestOptions()
    
    var ref: DatabaseReference!
    let storage = Storage.storage()
    
    
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
        
        // 1. 필수 항목 비어 있으면 오류 처리하기.
        guard let userId = self.userIdTextField.text,
              let description = self.descriptionTextView.text
        else { self.showBasicAlert(title: "내용을 입력하세요.", message: "내용은 필수 입력값입니다."); return}

        // 2. db ref 설정.
        self.ref = Database.database(url: "https://restaurants-e62b0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        // 3. 이미지가 있다면 이미지를 먼저 업로드.
        
        guard let storeKey = StoreSingleton.shared.store?.storeKey
        else { fatalError("인터넷 연결 확인 필요") }
        
        
        for (index, image) in self.imageSet.enumerated() {
            guard let uploadImageData = image.jpegData(compressionQuality: 0.8)
            else { self.showBasicAlert(title: "업로드 실패", message: "인터넷 연결 또는 이미지 형식을 확인해주세요"); return}
            
            var data = Data()
            data = uploadImageData
            let filePath = "images/\(storeKey)/\(self.userIdTextField?.text ?? "defaultUser")\(Date().toString()).png"
            let metaData = StorageMetadata()
            metaData.contentType = "image/png"
            
            // 올리기 시작
            let uploadTask =
                self.storage.reference().child("\(filePath)").putData(data, metadata: metaData) {
                    [self] (metadata, error) in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        showBasicAlert(title: "이미지 업로드 실패", message: "인터넷 연결을 확인하세요")
                        return
                    }
                }
            
            let image = filePath
            self.images.append(image)
            
            uploadTask.observe(.success) { snapshot in
            
                if index == self.imageSet.count {
                    // 이미지를 모두 storage에 올린 뒤 작업 시작.
                    
                    
                }
                
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
