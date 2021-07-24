//
//  ListStoreViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/24.
//

import UIKit
import Firebase
import CodableFirebase

class ListStoreViewController: UIViewController {

    @IBOutlet weak var storeTableView: UITableView!
    
    var ref: DatabaseReference!
    
    var stores = Dictionary<String, Store>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.storeTableView.delegate = self
        self.storeTableView.dataSource = self
        

        ref = Database.database(url: "https://restaurants-e62b0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        getStoresInfoFromDatabase()
    }
    

    func getStoresInfoFromDatabase() {
        self.ref.child("stores").getData{ (error, snapshot) in
        
            if let error = error {
                print(error.localizedDescription)
            } else if snapshot.exists() {
                guard let value = snapshot.value else {return}
                do { let store = try FirebaseDecoder().decode(Dictionary<String, Store>.self, from: value)
                    self.stores = store
                    DispatchQueue.main.async {
                        self.storeTableView.reloadData()
                    }
                } catch let err {
                    print(err.localizedDescription)
                }
            }
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

extension ListStoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.storeTableView.dequeueReusableCell(withIdentifier: StoreTableViewCell.reuseIdentifier) as? StoreTableViewCell
        else { return UITableViewCell() }
        
        
        
        
        return cell
    }
    
    
}
