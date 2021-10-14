//
//  PhotosDetailSegmentViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/26.
//

import UIKit
import Firebase
import CodableFirebase

class PhotosDetailSegmentViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var ref: DatabaseReference!
    let storage = Storage.storage()
    
    var imageDatas = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(
            width: view.frame.size.width / 3 - 1,
            height: view.frame.size.width / 3 - 1)
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = 1.5
        flowLayout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = flowLayout
        self.getImagesFromServer()
        setUI()
    }

    private func setUI() {
        self.collectionView.backgroundColor = .white
        
    }
    
    private func getImagesFromServer() {
        
        self.ref = Database.database(url: "https://restaurants-e62b0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        guard let currentTabBarIndex = self.tabBarController?.selectedIndex,
              let storeKey = currentTabBarIndex == 0 ? MainTabStoreSingleton.shared.store?.storeKey :  StoreSingleton.shared.store?.storeKey
        else { fatalError("can't get storeKey") }
        
        self.ref.child("stores/\(storeKey)/images").observe(DataEventType.value, with: { (snapshot) in
            if snapshot.exists() {
                self.imageDatas = []
                guard let value = snapshot.value else { return }
                do {
                    let imageData = try FirebaseDecoder().decode([String: Image].self, from: value)
                    
                    for data in imageData {
                        self.imageDatas.append(data.value)
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                } catch let err {
                    print(err.localizedDescription)
                }
            }
        })
    }
    
}

extension PhotosDetailSegmentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: DetailPhotosCollectionViewCell.reuseIdentifier, for: indexPath) as? DetailPhotosCollectionViewCell
        else {print("can't get images"); return UICollectionViewCell()}
    
        let storageRef = storage.reference()
        let reference = storageRef.child("\(self.imageDatas[indexPath.row].imageUrl)")
        let placeholderImage = UIImage(named: "placeholder.jpg")
        cell.imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DetailPhotosCollectionViewCell
        else { return }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let imageModalViewController = storyBoard.instantiateViewController(withIdentifier: "EnlargedImageViewController") as? EnlargedImageViewController
        else { return }
        imageModalViewController.imagePassed = cell.imageView.image
        self.present(imageModalViewController, animated: true, completion: nil)
        
    }
    
   
    

}

