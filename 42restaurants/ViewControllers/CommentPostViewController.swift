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
        
    let imagePicker = OpalImagePickerController()
    var imageSet = [UIImage]()
    let phImageManager = PHImageManager.default()
    let phImageOption = PHImageRequestOptions()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    
        initializeOpalImagePicker()
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
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
