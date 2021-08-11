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

    private var _comments = [String: Comment]()
    var comments: [String: Comment] {
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
        if let storeKey = StoreSingleton.shared.store?.storeKey {
            self.ref.child("stores/\(storeKey)/comments").getData {
                (error, snapshot) in
                
                if let error = error {
                    print(error.localizedDescription)
                } else if snapshot.exists() {
                    guard let value = snapshot.value else { return }
                    do {
                        let commentsData = try FirebaseDecoder().decode([String: Comment].self, from: value)
                        self.comments = commentsData
                    } catch let err {
                        print(err.localizedDescription)
                    }
                    
                }
                
            }
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

        
        
        
        return cell
    }
    
    
}
