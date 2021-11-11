//
//  ReviewFilterViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/28.
//

import UIKit

private let filters: [Filter] = [
    Filter.latest,
    Filter.ratingHigh,
    Filter.oldest,
    Filter.ratingLow
]

class ReviewFilterViewController: UIViewController {

    @IBOutlet weak var reviewFilterCollectionView: UICollectionView!
    private var collectionViewOnLoadExecuteJustOnce: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.reviewFilterCollectionView.delegate = self
        self.reviewFilterCollectionView.dataSource = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveGetCurrentReviewFilterNotification),
                                               name: Notification.Name("getCurrentReviewFilter"),
                                               object: nil)
        
        setUpView()
        setUpReviewFilterCollectionView()
        
    }
    
    
    @objc func didReceiveGetCurrentReviewFilterNotification() {
        guard let indexPath = self.reviewFilterCollectionView.indexPathsForSelectedItems?.first,
              let cell = self.reviewFilterCollectionView.cellForItem(at: indexPath) as? ReviewFilterCollectionViewCell,
              let filter = cell.reviewFilterLabel?.text
        else { print("error on didReceiveGetCurrentReviewFilterNotification function"); return }
        
        NotificationCenter.default.post(name: Notification.Name("reviewFilterSelected"),
                                        object: nil,
                                        userInfo: ["reviewFilter": filter])
    }
 
    
    private func setUpView() {
        self.view.backgroundColor = .white
        self.reviewFilterCollectionView.backgroundColor = Config.shared.application60Color
    }
    
    private func setUpReviewFilterCollectionView() {
        self.reviewFilterCollectionView.collectionViewLayout = FilterCollectionViewFlowLayout()
        if let flowLayout = self.reviewFilterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }

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
extension ReviewFilterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.reviewFilterCollectionView.dequeueReusableCell(withReuseIdentifier: ReviewFilterCollectionViewCell.reuseIdentifier, for: indexPath)
        as? ReviewFilterCollectionViewCell
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
    
    private func selectFirstCell(_ cell: ReviewFilterCollectionViewCell, _ indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.reviewFilterCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
            cell.onSelected()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ReviewFilterCollectionViewCell
        else { print("can't select filter cell"); return }
        
        cell.onSelected()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ReviewFilterCollectionViewCell
        else { print("can't select filter cell"); return }
        
        cell.onDeselected()
    }
}

extension ReviewFilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 50)
    }
}
