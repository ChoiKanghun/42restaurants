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

        setDelegates()
        setCollectionViewFlowLayout()
        
        self.getImagesFromServer()
        setUI()
    }

    private func setUI() {
        self.collectionView.backgroundColor = .white
    }
    
    private func setDelegates() {
            
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    
    private func setCollectionViewFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(
            width: view.frame.size.width / 3 - 1,
            height: view.frame.size.width / 3 - 1)
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = 1.5
        flowLayout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    private func getImagesFromServer() {
        
        self.ref = Database.database(url: Config.shared.referenceAddress).reference()
        
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
                    self.filterImages(storeKey: storeKey)
                    
                } catch let err {
                    print(err.localizedDescription)
                }
            }
        })
    }
    
    private func filterImages(storeKey: String) {
        let currentUser = FirebaseAuthentication.shared.getUserEmail()
        guard let userIdBeforeAtSymbol = currentUser.components(separatedBy: "@").first
        else { print("에러 날 리가 없는 곳;filterImages"); return }
        
        self.ref.child("users/\(userIdBeforeAtSymbol)/blockedImages").getData { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            else if snapshot.exists() {
                guard let value = snapshot.value else { print("can't get snapshot value"); return }
                guard let blockedImageDictionary = value as? [String: String]
                else { print("can't get imageKeyValues "); return }
                
                for blockedImageUrl in blockedImageDictionary.values {
                    self.imageDatas = self.imageDatas.filter({
                        $0.imageUrl != blockedImageUrl
                    })
                }
                self.imageDatas = self.imageDatas.sorted(by: { $0.createDate > $1.createDate })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:  {
                    self.collectionView.reloadData()
                })

            } else {
                self.imageDatas = self.imageDatas.sorted(by: { $0.createDate > $1.createDate })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:  {
                    self.collectionView.reloadData()
                })
                
            }
        }
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
    
    // 클릭한 셀의 이미지를 가져와서 EnlargedImageViewController의 이미지 변수에 세팅해주고 VC를 띄운다.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Name("showEnlargedImage"),
                                        object: nil,
                                        userInfo: ["imageUrl": self.imageDatas[indexPath.row].imageUrl])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 전제: DetailVC의 view 높이가 140임.
        // segmentView의 높이가 31, top Constraint가 15.
        if scrollView == self.collectionView {
            let viewHeight = UIScreen.main.bounds.height
            let contentOffset = scrollView.contentOffset.y
            
            if (contentOffset > viewHeight - (140 + 31 + 15)) {
                NotificationCenter.default.post(
                    name: Notification.Name("HideDetailView"),
                    object: nil,
                    userInfo: nil)
            }
            else {
                NotificationCenter.default.post(
                    name: Notification.Name("ShowDetailView"),
                    object: nil,
                    userInfo: nil)
            }
        }
    }
}

