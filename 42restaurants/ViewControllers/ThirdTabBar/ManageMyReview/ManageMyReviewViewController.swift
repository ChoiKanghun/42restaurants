//
//  ManageMyReviewViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/11/04.
//

import UIKit
import Firebase
import CodableFirebase

class ManageMyReviewViewController: UIViewController {

    var storeNameAndCreateDates: [(String, Double)] = []
    var comments: [Comments] = []
    var ref: DatabaseReference!
    let userId = FirebaseAuthentication.shared.getUserEmail()
    let storageRef = Storage.storage().reference()
    
    @IBOutlet weak var myReviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myReviewTableView.delegate = self
        self.myReviewTableView.dataSource = self

        self.ref = Database.database(url: "https://restaurants-e62b0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        setUI()
        LoadingService.showLoading()
        fetchComments()
    }
    
    private func setUI() {
        self.myReviewTableView.backgroundColor = .white
    }
    
    private func fetchComments() {
        self.ref.child("stores").observe(DataEventType.value, with: { snapshot in
            
            if snapshot.exists() {
                self.comments = []
                guard let value = snapshot.value else { return }
                do {
                    let storesData = try FirebaseDecoder().decode([String: StoreInfo].self, from: value)
                    
                    for storeData in storesData {
                        let store: Store = Store(storeKey: storeData.key, storeInfo: storeData.value)
                        for element in store.storeInfo.comments {
                            let commentPair = Comments.init(commentKey: element.key, comment: element.value)
                            if element.value.userId == self.userId {
                                self.comments.append(commentPair)
                                self.storeNameAndCreateDates.append(
                                    (store.storeInfo.name, commentPair.comment.createDate))
                            }
                        }
                        self.comments = self.comments.sorted(by: { $0.comment.createDate > $1.comment.createDate })
                        self.storeNameAndCreateDates = self.storeNameAndCreateDates.sorted(by: {
                            $0.1 > $1.1 // .1은 createDate를 의미한다.
                        })
                    }
                    DispatchQueue.main.async {
                        self.myReviewTableView.reloadData()
                    }
                } catch let e {
                    print("error while fetching comments")
                    print(e.localizedDescription)
                }
            }
        })
    }
    
}

extension ManageMyReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.myReviewTableView.dequeueReusableCell(
                withIdentifier: ManageMyReviewTableViewCell.reuseIdentifier) as? ManageMyReviewTableViewCell
        else { return UITableViewCell() }
        
        let comment = self.comments[indexPath.row].comment
        cell.storeNameLabel?.text = self.storeNameAndCreateDates[indexPath.row].0
        cell.ratingLabel?.text = "\(String(format: "%.1f", comment.rating)))"
        cell.descriptionLabel?.text = comment.description
        if let images = comment.images,
           let firstImage = images.first {
            let reference = self.storageRef.child(firstImage.value.imageUrl)
            cell.commentImageView.sd_setImage(with: reference)
        } else {
            cell.commentImageView.image = UIImage(named: "imageNotFound")
        }
        if isAbleToEdit(comment.createDate) == true {
            cell.touchFreeView.alpha = 0
        } else {
            cell.touchFreeView.alpha = 0.3
        }
        
        
        return cell
    }

    private func isAbleToEdit(_ createDate: Double) -> Bool {
        let now = Date().toDouble()
        let comparedTime = now - createDate
        if comparedTime > 3600 * 24 * 2 { // 이틀 = 3600 * 24 * 2 초
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isAbleToEdit(self.comments[indexPath.row].comment.createDate) == false {
            showBasicAlert(title: "리뷰 수정 기간이 지났습니다.", message: "리뷰 수정은 이틀 동안 가능합니다 !")
        } else {
            
        }
        
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    

}
