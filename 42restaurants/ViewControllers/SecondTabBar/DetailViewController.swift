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
    
    @IBOutlet weak private var storeInfoView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var photosView: UIView!
    var reviewsView: UIView!
    var mapView: UIView!
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            photosView.alpha = 1
            reviewsView.alpha = 0
            mapView.alpha = 0
        } else if sender.selectedSegmentIndex == 1 {
            photosView.alpha = 0
            reviewsView.alpha = 1
            mapView.alpha = 0
        } else {
            photosView.alpha = 0
            reviewsView.alpha = 0
            mapView.alpha = 1
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarHidden(isHidden: false)
        setupUI()
    
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setStatusBarBackgroundColor()
        self.setNavigationBarBackgroundColor()
        self.storeInfoView.backgroundColor = Config.shared.applicationThemeColor
        self.view.backgroundColor = Config.shared.applicationThemeColor
        self.storeNameLabel.tintColor = .white
        self.categoryLabel.tintColor = .white
        self.ratingLabel.tintColor = .white
        self.addressLabel.tintColor = .white
        
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
       
        instantiateSegmentedViewControllers()
    }
    
    // segmentedControl과 연결된 ViewController들을 초기화하고,
    // 해당 view들을 현재(self) view에 추가한다.
    private func instantiateSegmentedViewControllers() {
        guard let photosVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotosVC"),
              let reviewsVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewVC"),
              let detailMapVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailMapVC")
        else { fatalError("can't find PhotosVC") }
        
        self.addChild(photosVC)
        self.addChild(reviewsVC)
        self.addChild(detailMapVC)
        photosVC.view.translatesAutoresizingMaskIntoConstraints = false
        reviewsVC.view.translatesAutoresizingMaskIntoConstraints = false
        detailMapVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(reviewsVC.view)
        self.view.addSubview(detailMapVC.view)
        self.view.addSubview(photosVC.view)
        
        NSLayoutConstraint.activate([
            photosVC.view.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 10),
            photosVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            photosVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            photosVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            reviewsVC.view.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 10),
            reviewsVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            reviewsVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            reviewsVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            detailMapVC.view.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 10),
            detailMapVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            detailMapVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            detailMapVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            
        ])
        
        
        self.photosView = photosVC.view
        self.reviewsView = reviewsVC.view
        self.mapView = detailMapVC.view
        
        
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
