//
//  DetailViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/26.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        guard let currentTabBarIndex = self.tabBarController?.selectedIndex
        else { return }
        
        guard let store = currentTabBarIndex == 0 ? MainTabStoreSingleton.shared.store : StoreSingleton.shared.store
        else { print("can't get store Singleton"); return }
        
        self.storeNameLabel?.text = store.storeInfo.name
        self.addressLabel?.text = store.storeInfo.address
        self.categoryLabel?.text = store.storeInfo.category
        self.ratingLabel?.text = "\(store.storeInfo.rating) / 5"
       
    }

    /*o
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
