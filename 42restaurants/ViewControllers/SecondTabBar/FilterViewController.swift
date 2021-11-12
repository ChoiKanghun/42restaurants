//
//  FilterViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/23.
//

import UIKit

private let filters: [Filter] = [
    Filter.latest,
    Filter.ratingHigh,
    Filter.reviewCount,
    Filter.nearest,
    Filter.oldest,
    Filter.ratingLow
]

class FilterViewController: UIViewController {
    @IBOutlet weak var filterCollectionView: UICollectionView!
    private var collectionViewOnLoadExecuteJustOnce: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.filterCollectionView.delegate = self
        self.filterCollectionView.dataSource = self
        addNotifications()
        setUI()
        setUpFilterCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = Config.shared.application60Color
        self.filterCollectionView.backgroundColor = Config.shared.application60Color
    }
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didReceiveCategoryDidChangeNotification(_:)),
                                               name: Notification.Name("categoryDidChange"), object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector:  #selector(didReceiveCategoryDidChangeNotification(_:)),
                                               name: Notification.Name("changeToCurrentFilter"), object: nil)
    }
    
    @objc func didReceiveCategoryDidChangeNotification(_ noti: Notification) {
        guard let indexPath = self.filterCollectionView.indexPathsForSelectedItems?.first,
              let cell = self.filterCollectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell,
              let filter = cell.filterLabel?.text
        else { print("error on didReceiveCategorydidChangeNotification function"); return }
        
        NotificationCenter.default.post(name: Notification.Name("filterSelected"),
                                        object: nil,
                                        userInfo: ["filter": filter])
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
    }
    
    private func setUpFilterCollectionView() {
        self.filterCollectionView.collectionViewLayout = FilterCollectionViewFlowLayout()
        if let flowLayout = self.filterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }

    }
}

extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.filterCollectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.reuseIdentifier, for: indexPath)
        as? FilterCollectionViewCell
        else { print("error: Can't get filter CollectionViewCell"); return UICollectionViewCell() }
     
        if indexPath.row == 0 && self.collectionViewOnLoadExecuteJustOnce == false {
            collectionViewOnLoadExecuteJustOnce = true
            self.selectFirstCell(cell, indexPath)
        }
        cell.configure(labelText: filters[indexPath.row].filterName)
        
        if cell.isSelected == true { cell.onSelected() }
        else { cell.onDeselected() }
        
        return cell
    }
    
    private func selectFirstCell(_ cell: FilterCollectionViewCell, _ indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.filterCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
            
            cell.onSelected()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell
        else { print("can't select filter cell"); return }
        
        cell.onSelected()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell
        else { print("can't select filter cell"); return }
        
        cell.onDeselected()
    }
}

extension FilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 50)
    }
}
