//
//  MainMapViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/20.
//

import UIKit
import NMapsMap
import CoreLocation
import Firebase
import CodableFirebase
import FirebaseUI

class MainMapViewController: UIViewController {

    @IBOutlet weak var mapView: NMFMapView!
    
    // pop up view IBOutlets
    @IBOutlet weak var popUpImageView: UIImageView!
    @IBOutlet weak var popUpStoreNameLabel: UILabel!
    @IBOutlet weak var popUpRatingLabel: UILabel!
    @IBOutlet weak var popUpCommentCountLabel: UILabel!
    @IBOutlet weak var popUpView: UIView!
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.startUpdatingLocation() // 안해주면 위치 안 받아옴.

        return manager
    }()
    
    let userMarker = NMFMarker()

    var ref: DatabaseReference!
    let storage = Storage.storage()
    
    var stores = [Store]()

    // 특정 객체를 지도에서 선택했을 때 이벤트
    var handler: NMFOverlayTouchHandler = { overlay -> Bool in
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.positionMode = .normal
            
        ref = Database.database(url: "https://restaurants-e62b0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        self.mapView.touchDelegate = self
        self.popUpView.isHidden = true
        self.handler = { (overlay) -> Bool in
            
            self.popUpView.isHidden = false
            if let storeName = overlay.userInfo["storeName"] as? String,
               let rating = overlay.userInfo["rating"] as? String,
               let commentCount = overlay.userInfo["commentCount"] as? String,
               let imageUrl = overlay.userInfo["imageUrl"] as? String {
                
                let storageRef = self.storage.reference()
                let imageRef = storageRef.child("\(imageUrl)")
                DispatchQueue.main.async {
                    self.popUpStoreNameLabel.text = storeName
                    self.popUpRatingLabel.text = rating
                    self.popUpCommentCountLabel.text = "방문자리뷰 \(commentCount)"
                    self.popUpImageView.sd_setImage(with: imageRef)
                }
            } else {
                print("coverting error")
            }
            return true
        }
        
        self.ref.child("stores").getData{ (error, snapshot) in
        
            if let error = error {
                print(error.localizedDescription)
            } else if snapshot.exists() {
                guard let value = snapshot.value else {return}
                do {
                    let storesData = try FirebaseDecoder().decode([String: StoreInfo].self, from: value)
                    
                    for storeData in storesData {
                        let store: Store = Store(storeKey: storeData.key, storeInfo: storeData.value)
                        self.stores.append(store)
                    }
                    self.setStores()
                } catch let err {
                    print(err.localizedDescription)
                }
            }
            
        }
        
        
    }
    


}

extension MainMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            if let coordinate = locationManager.location?.coordinate {
                moveCameraToUserLocation(coordinate)
            }
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음.")
            self.locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("GPS 권한 요청 거부됨")
            self.locationManager.requestWhenInUseAuthorization()
        default:
            print("GPS Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.first
        else {return}
        
        let NMGCurrentLocation =
            NMGLatLng(lat: location.coordinate.latitude,
                      lng: location.coordinate.longitude)
        
        print("location: \(NMGCurrentLocation)")
        userMarker.position = NMGCurrentLocation
        userMarker.mapView = mapView

        
        

    }
    
    /*
     위치를 최초로 받아올 때
     user의 위치에 맞게 카메라를 이동시키고
     user를 표시하는 marker의 속성을 지정한다.
     */
    func moveCameraToUserLocation(_ coordinate: CLLocationCoordinate2D) {
        let NMGCurrentLocation = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        let cameraPosition = NMGCurrentLocation
        let cameraUpdate = NMFCameraUpdate(scrollTo: cameraPosition)
        mapView.moveCamera(cameraUpdate)
        
        userMarker.captionText = "ME"
        if let userLocationImage = UIImage(systemName: "circle.fill") {
            let overlayImage = NMFOverlayImage.init(image: userLocationImage)
            userMarker.iconImage = overlayImage
        }
        userMarker.iconTintColor = UIColor.systemRed
    }
    
    func setStores() {
        var markers: [NMFMarker] = [NMFMarker]()
        
        for (index, element) in self.stores.enumerated() {
            let marker = NMFMarker()
            print(element.storeInfo.latitude)
            marker.position = NMGLatLng(
                lat: Double(element.storeInfo.latitude),
                lng: Double(element.storeInfo.longtitude))
            markers.append(marker)
            marker.width = 40
            marker.height = 40
            marker.userInfo = ["storeName": element.storeInfo.name,
                               "rating": "\(element.storeInfo.rating)",
                               "commentCount": "\(element.storeInfo.commentCount)",
                               "imageUrl": element.storeInfo.mainImage]
            marker.touchHandler = self.handler
            DispatchQueue.main.async {
                if let imageName: String = Category.init(rawValue: element.storeInfo.category)?.imageName {
                    marker.iconImage = NMFOverlayImage(name: "\(imageName)")
                }
                
                marker.mapView = self.mapView
            }
            if index == self.stores.count - 1 {
                DispatchQueue.main.async {
                    self.mapView.reloadInputViews()
                }
            }
            
        }

        
    }
    
}


extension MainMapViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        DispatchQueue.main.async {
            self.popUpView.isHidden = true
        }
    }
}
