//
//  ReviewDetailSegmentViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/26.
//

import UIKit
import Firebase
import CodableFirebase

class ReviewDetailSegmentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    

    private var _comments = [Comment]()
    var comments: [Comment] {
        get {
            return _comments
        }
        set (newVal) {
            self._comments = newVal
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var ref: DatabaseReference!
    let storage = Storage.storage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        ref = Database.database(url: "https://restaurants-e62b0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        updateTableView()
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
        
        self._comments.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.reuseIdentifier, for: indexPath) as? ReviewTableViewCell
        else { return UITableViewCell() }

        if let imageDictionary = self.comments[indexPath.row].images {
            let images = imageDictionary.map { $0.value }
            cell.images = images
        } else {
            cell.images = []
        }
        
        cell.userIdLabel?.text = self.comments[indexPath.row].userId
        cell.descriptionLabel?.text = self.comments[indexPath.row].description
        cell.ratingLabel?.text = "\(self.comments[indexPath.row].rating)"
        
        return cell
    }
    
}
