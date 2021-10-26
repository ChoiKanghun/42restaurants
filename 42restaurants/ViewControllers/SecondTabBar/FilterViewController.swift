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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.filterCollectionView.delegate = self
        self.filterCollectionView.dataSource = self
        setUpView()
        setUpFilterCollectionView()
    }
    
    private func setUpView() {
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
     
        if indexPath.row == 0 { self.selectFirstCell(cell, indexPath) }
        cell.configure(labelText: filters[indexPath.row].filterName)
        
        return cell
    }
    
    private func selectFirstCell(_ cell: FilterCollectionViewCell, _ indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.filterCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
            cell.isSelected = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension FilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 50)
    }
}
