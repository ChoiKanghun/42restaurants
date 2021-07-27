//
//  CommentPostViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/26.
//

import UIKit
import OpalImagePicker
import Photos

class CommentPostViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    // 키보드 높이
    @IBOutlet weak var keyHeight: NSLayoutConstraint!
    
    let imagePicker = OpalImagePickerController()
    var imageSet = [UIImage]()
    let phImageManager = PHImageManager.default()
    let phImageOption = PHImageRequestOptions()
    
    
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
