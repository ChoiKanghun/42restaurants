//
//  ListStoreViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/24.
//

import UIKit
import Firebase
import CodableFirebase
import CoreLocation


class ListStoreViewController: UIViewController {

    @IBOutlet weak var storeTableView: UITableView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    var ref: DatabaseReference!
    let storage = Storage.storage()
    let categories: [Category] =
        [Category.all,
         Category.koreanAsian,
         Category.japaneseCutlet,
         Category.chinese,
         Category.western,
         Category.chickenPizza,
         Category.bunsik,
         Category.mexican,
         Category.fastFood,
         Category.meat,
         Category.cafe]
    
    
    var stores = [Store]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.storeTableView.delegate = self
        self.storeTableView.dataSource = self
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
        

        ref = Database.database(url: "https://restaurants-e62b0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        getStoresInfoFromDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // view will appear에 두는 이유는 리스트 클릭 후 다시 돌아올 때를 대비하기 위해서.
        setUI()
    }

    private func setUI() {
        self.setStatusBarBackgroundColor()
        self.setNavigationBarBackgroundColor()
        self.storeTableView.backgroundColor = Config.shared.application60Color
        self.setNavigationBarHidden(isHidden: true)
        
    }

    private func getDistanceFromCurrentLocation(_ targetLatitude: Double, _ targetLongitude: Double) -> CLLocationDistance {
        let currentLocationLatitude = UserDefaults.standard.double(forKey: "currentLocationLatitude")
        let currentLocationLongitude = UserDefaults.standard.double(forKey: "currentLocationLongitude")
        
        let targetLocation = CLLocationCoordinate2D(latitude: targetLatitude, longitude: targetLongitude)
        let currentLocation = CLLocationCoordinate2D(latitude: currentLocationLatitude, longitude: currentLocationLongitude)
        
        return targetLocation.distance(from: currentLocation)
    }
//
    
    
    
    
    func getStoresInfoFromDatabase() {
        self.ref.child("stores").observe(DataEventType.value, with: { (snapshot) in
            
            if snapshot.exists() {
                self.stores = []
                guard let value = snapshot.value else {return}
                do {
                    let storesData = try FirebaseDecoder().decode([String: StoreInfo].self, from: value)
                    
                    for storeData in storesData {
                        let store: Store = Store(storeKey: storeData.key, storeInfo: storeData.value)
                        self.stores.append(store)
                    }
                    self.stores = self.stores.sorted(by: { $0.storeInfo.createDate < $1.storeInfo.createDate })
                    
                    DispatchQueue.main.async {
                        self.storeTableView.reloadData()
                    }
                } catch let err {
                    print(err.localizedDescription)
                }
            }
        })
        
    }
    
   
    @IBAction func touchUpFilterButton(_ sender: Any) {
        let filterMenu = UIAlertController(title: nil, message: "적용할 필터를 선택해주세요.", preferredStyle: .actionSheet)
        
        // 옵션 - 시간순
        let filterByDate = UIAlertAction(title: "등록된 시간 순", style: .default, handler: { _ in
            self.stores = self.stores.sorted(by: { $0.storeInfo.createDate < $1.storeInfo.createDate })
            DispatchQueue.main.async { self.storeTableView.reloadData() }
        })
        
        // 옵션 - 가까운순
        let filterByDistance = UIAlertAction(title: "가까운 순", style: .default, handler: { _ in
            self.stores = self.stores.sorted(
                by: { self.getDistanceFromCurrentLocation($0.storeInfo.latitude, $0.storeInfo.longtitude) <
                    self.getDistanceFromCurrentLocation($1.storeInfo.latitude, $1.storeInfo.longtitude) })
            DispatchQueue.main.async { self.storeTableView.reloadData() }
        })
        
        // 옵션 - 리뷰 많은 순
        let filterByReviewCount = UIAlertAction(title: "리뷰 많은 순", style: .default, handler: { _ in
            self.stores = self.stores.sorted(by: { $0.storeInfo.commentCount > $1.storeInfo.commentCount })
            DispatchQueue.main.async { self.storeTableView.reloadData() }
        })
        
        // 옵션 - 평점 높은 순
        let filterByRating = UIAlertAction(title: "평점 높은 순", style: .default, handler: { _ in
            self.stores = self.stores.sorted(by: { $0.storeInfo.rating > $1.storeInfo.rating })
            DispatchQueue.main.async { self.storeTableView.reloadData() }
        })
        
        filterMenu.addAction(filterByDate)
        filterMenu.addAction(filterByDistance)
        filterMenu.addAction(filterByReviewCount)
        filterMenu.addAction(filterByRating)
    
        self.present(filterMenu, animated: true, completion: nil)
    }
}

extension ListStoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.storeTableView.dequeueReusableCell(withIdentifier: StoreTableViewCell.reuseIdentifier) as? StoreTableViewCell
        else { return UITableViewCell() }
        
        let store = self.stores[indexPath.row]
        
        cell.nameLabel?.text = store.storeInfo.name
        cell.addressLabel?.text = store.storeInfo.address
        cell.rateLabel?.text = "\(store.storeInfo.rating)"
        cell.categoryLabel?.text = store.storeInfo.category
        
        let storageRef = storage.reference()
        let reference = storageRef.child("\(store.storeInfo.mainImage)")
        let placeholderImage = UIImage(named: "placeholder.jpg")
        cell.storeImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        hideLoadingWhenTableViewDidAppear(indexPath)
        return cell
    }
    
    private func hideLoadingWhenTableViewDidAppear(_ indexPath: IndexPath) {
        if indexPath.row == self.stores.count - 1 { LoadingService.hideLoading() }
    }
    
    
}

extension ListStoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        StoreSingleton.shared.store = self.stores[indexPath.row]
        
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        else { return }
            
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}


extension ListStoreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCellReuseIdentifier", for: indexPath) as? CategoryCollectionViewCell
        else { return UICollectionViewCell() }
        
        if indexPath.row == 0 { selectFirstCell(cell, indexPath) }
        cell.categoryLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        cell.setCellLabelText(self.categories[indexPath.row].rawValue)
        DispatchQueue.main.async {
            cell.setCategoryCollectionViewCellUI()
        }
//        cell.fitCellSizeToLabelSize()
        
        return cell
        
    }
    
    private func selectFirstCell(_ cell: CategoryCollectionViewCell, _ indexPath: IndexPath) {
        self.categoryCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
        cell.isSelected = true
        
    }
}

extension ListStoreViewController: UICollectionViewDelegateFlowLayout {

}


