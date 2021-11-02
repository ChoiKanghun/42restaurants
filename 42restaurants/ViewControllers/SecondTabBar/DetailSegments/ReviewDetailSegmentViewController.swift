//
//  ReviewDetailSegmentViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/26.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import CodableFirebase
import FirebaseUI

class ReviewDetailSegmentViewController: UIViewController {

    @IBOutlet weak var reviewTableView: UITableView!
    
    private var updateJustOnceFlag: Bool = false
    
    private var comments = [Comment]()
    
    
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reviewTableView.delegate = self
        self.reviewTableView.dataSource = self

        ref = Database.database(url: "https://restaurants-e62b0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveReviewFilterSelectedNotification(_:)),
                                               name: Notification.Name("reviewFilterSelected"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveReviewSubmitDone(_:)),
                                               name: Notification.Name("reviewSubmitDone"), object: nil)
        
        
        refreshControl.addTarget(self, action: #selector(onPullToReloadTableView), for: .valueChanged)
        self.reviewTableView.addSubview(refreshControl)
        
        setUI()
        setTableView()
    }
    
    @objc func onPullToReloadTableView() {
        if self.comments.count == 0 {
            self.setTableView()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func didReceiveReviewSubmitDone(_ noti: Notification) {
        self.showBasicAlert(title: "제출 완료", message: "리뷰가 성공적으로 등록되었습니다 !")
    }
    
    @objc func didReceiveReviewFilterSelectedNotification(_ noti: Notification) {
        guard let reviewFilter = noti.userInfo?["reviewFilter"] as? String
        else { print("can't get reviewFilter notification"); return }
        
        switch reviewFilter {
        case Filter.latest.filterName:
            self.comments = self.comments.sorted(by: { $0.createDate > $1.createDate })
        case Filter.ratingHigh.filterName:
            self.comments = self.comments.sorted(by: { $0.rating > $1.rating })
        case Filter.oldest.filterName:
            self.comments = self.comments.sorted(by: { $0.createDate < $1.createDate })
        case Filter.ratingLow.filterName:
            self.comments = self.comments.sorted(by: { $0.rating < $1.rating })
        default:
            self.comments = self.comments.sorted(by: { $0.createDate > $1.createDate })
            print("default filter notification in")
        }
        DispatchQueue.main.async {
            self.reviewTableView.reloadData()
        }
    }
    
    private func setUI() {
        self.reviewTableView.backgroundColor = .white
        
        
    }
    
    private func setTableView() {
        self.reviewTableView.estimatedRowHeight = 270
        self.updateTableView()
    }
    
    private func updateTableView() {
        if let tabBarIndex = self.tabBarController?.selectedIndex,
           let storeKey = tabBarIndex == 0 ? MainTabStoreSingleton.shared.store?.storeKey : StoreSingleton.shared.store?.storeKey {
            self.ref.child("stores/\(storeKey)/comments").observe(DataEventType.value, with: {
                (snapshot) in
                if snapshot.exists() {
                    guard let value = snapshot.value else { return }
                    do {
                        let commentsData = try FirebaseDecoder().decode([String: Comment].self, from: value)
                        self.comments = commentsData.values.sorted(by:  { $0.createDate < $1.createDate } )
                        DispatchQueue.main.async {
                            self.reviewTableView.reloadData()
                        }
                    } catch let err {
                        print(err.localizedDescription)
                    }
                    
                }
            })
        }
        
    }
    
}

extension ReviewDetailSegmentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.comments.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.reviewTableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.reuseIdentifier, for: indexPath) as? ReviewTableViewCell
        else { return UITableViewCell() }
        
//        DispatchQueue.main.async {
//            if let index: IndexPath = tableView.indexPath(for: cell) {
//                if index.row == indexPath.row {
//                    if let image = self.comments[indexPath.row].images?.first {
//                        let reference = self.storageRef.child("\(image.value.imageUrl)")
//                        cell.reviewImageView.sd_setImage(with: reference)
//
//                    }
//                }
//            }
//        }
        
        if let images = self.comments[indexPath.row].images?.values.map({ $0 }) {
            cell.images = images
            


        } else {
            cell.images = [Image]()
            
        }
        
        cell.setUserIdLabelText(userId: self.comments[indexPath.row].userId)
        cell.setDescriptionLabelText(description: self.comments[indexPath.row].description)
        cell.setRatingLabelText(rating: self.comments[indexPath.row].rating)
        cell.setImage()
        self.reviewTableView.reloadRows(at: [indexPath], with: .none)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.reviewTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - 테이블 뷰 상단 뷰 height를 줄이거나 넓힘.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 전제: DetailVC의 view 높이가 140임.
        // segmentView의 높이가 31, top Constraint가 15.
        
        if scrollView == self.reviewTableView {
            let viewHeight = UIScreen.main.bounds.height
            let contentOffset = scrollView.contentOffset.y
            

            if (contentOffset > viewHeight - (140 + 50 + 15)) {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
