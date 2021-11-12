//
//  ManageMyStoreViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/20.
//

import UIKit
import Firebase
import CodableFirebase

class ManageMyStoreViewController: UIViewController {

    @IBOutlet weak var myStoreTableView: UITableView!
    
    var ref: DatabaseReference!
    let storage = Storage.storage()
    var stores = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myStoreTableView.delegate = self
        self.myStoreTableView.dataSource = self
        
        self.ref = Database.database(url: Config.shared.referenceAddress).reference()
        
        self.dismissIfNotLoggedIn()
        setMyStoreTableViewUI()
        setMyStoreTableViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBarHidden(isHidden: false)
    }
    
    private func setMyStoreTableViewUI() {
        self.myStoreTableView.backgroundColor = .white
    }
    
    private func setMyStoreTableViewData() {
        self.ref.child("stores").observe(DataEventType.value, with: { snapshot in
            
            if snapshot.exists() {
                self.stores = []
                guard let value = snapshot.value else {return}
                do {
                    let storesData = try FirebaseDecoder().decode([String: StoreInfo].self, from: value)
                    
                    for storeData in storesData {
                        let store: Store = Store(storeKey: storeData.key, storeInfo: storeData.value)
                        if store.storeInfo.enrollUser == FirebaseAuthentication.shared.getUserEmail() {
                            self.stores.append(store)
                        }
                    }
                    DispatchQueue.main.async {
                        if self.stores.count == 0 { self.myStoreTableView.isHidden = true }
                        else { self.myStoreTableView.isHidden = false }
                        self.myStoreTableView.reloadData()
                    }
                    
                } catch let err {
                    print(err.localizedDescription)
                }
            }
        })
    }

}

extension ManageMyStoreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.stores.count == 0 {
            self.myStoreTableView.setBackgroundWhenNoData()
        } else {
            self.myStoreTableView.resetBackground()
        }
        return self.stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.myStoreTableView.dequeueReusableCell(withIdentifier: MyStoreTableViewCell.reuseIdentifier) as? MyStoreTableViewCell
        else { print("can't get mystoretableviewcell"); return UITableViewCell() }
        
        cell.store = self.stores[indexPath.row]
        
        return cell
    }
 
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        guard let modifyMyStoreVC = self.storyboard?.instantiateViewController(
            withIdentifier: ModifyMyStoreViewController.storyboardIdentifier) as? ModifyMyStoreViewController
        else { return }
        
        self.navigationController?.pushViewController(modifyMyStoreVC, animated: true)
        let store = self.stores[indexPath.row]
        modifyMyStoreVC.storeData = store
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
