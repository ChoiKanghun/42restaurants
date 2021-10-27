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

import FirebaseMessaging

class MainMapViewController: UIViewController {

    @IBOutlet weak var mapView: NMFMapView!
    
    // pop up view IBOutlets
    @IBOutlet weak var popUpImageView: UIImageView!
    @IBOutlet weak var popUpStoreNameButton: UIButton!
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
        
        callMessaging()
        
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
               let imageUrl = overlay.userInfo["imageUrl"] as? String,
               let store = overlay.userInfo["store"] as? Store {
                
                MainTabStoreSingleton.shared.store = store
                
                let storageRef = self.storage.reference()
                let imageRef = storageRef.child("\(imageUrl)")
                DispatchQueue.main.async {
                    let buttonText = NSAttributedString(string: storeName)
                    self.popUpStoreNameButton.setAttributedTitle(buttonText, for: .normal)
                    self.popUpRatingLabel.text = rating
                    self.popUpCommentCountLabel.text = "방문자리뷰 \(commentCount)"
                    self.popUpImageView.sd_setImage(with: imageRef)
                }
            } else {
                print("coverting error")
            }
            return true
        }
        
        self.ref.child("stores").observe(DataEventType.value, with: { snapshot in
            
            if snapshot.exists() {
                self.stores = []
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
        })
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUI()
    }

    private func setUI() {
        self.setNavigationBarHidden(isHidden: true)
        self.setStatusBarBackgroundColor()
        self.popUpView.backgroundColor = Config.shared.application30Color
    }
    
    @IBAction func touchUpStoreNameButton(_ sender: Any) {

        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func touchUpMyLocationButton(_ sender: Any) {
        let currentLocationLatitude = UserDefaults.standard.double(forKey: "currentLocationLatitude")
        let currentLocationLongitude = UserDefaults.standard.double(forKey: "currentLocationLongitude")
        let currentLocation = CLLocationCoordinate2D(latitude: currentLocationLatitude,
                                                     longitude: currentLocationLongitude)
        self.moveCameraToUserLocation(currentLocation)
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
//        self.currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//
        let NMGCurrentLocation =
            NMGLatLng(lat: location.coordinate.latitude,
                      lng: location.coordinate.longitude)
        print("latitude: ",location.coordinate.latitude)
        print("longitude: ", location.coordinate.longitude)
        UserDefaults.standard.set(location.coordinate.latitude, forKey: "currentLocationLatitude")
        UserDefaults.standard.set(location.coordinate.longitude, forKey: "currentLocationLongitude")
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
            marker.position = NMGLatLng(
                lat: Double(element.storeInfo.latitude),
                lng: Double(element.storeInfo.longtitude))
            markers.append(marker)
            marker.width = 40
            marker.height = 40
            marker.userInfo = ["storeName": element.storeInfo.name,
                               "rating": "\(element.storeInfo.rating)",
                               "commentCount": "\(element.storeInfo.commentCount)",
                               "imageUrl": element.storeInfo.mainImage,
                               "store": element]
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

// delete this method later.
// this method is just to test node.js server works fine.
extension MainMapViewController: MessagingDelegate {
    
    func callMessaging() {
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            
            
            if let error = error {
                print("error fetching FCM Regsier token: \(error)")
            } else if let token = token {
                print("FCM reg token: \(token)")
                
            }
            self.deleteThisMethodLater(token: token)
        }
    }
    
    func deleteThisMethodLater(token: String?) {

        guard let token = token
        else { print("error on getting token "); return}
        let userName = "kchoi"
        let queryString = "?" + "registrationToken=" + token + "&userName=" + userName
        
        let url: URL = URL(string: "http://192.168.0.25:3000/\(queryString)")!
        
        
        
        httpGet(url: url, completionHandler: { d, r, e in
            
            guard let data = d else { return }
            print(String(data: data, encoding: .utf8)!)
        
        })
    }
    
    func httpGet(url: URL, completionHandler: @escaping( Data?, URLResponse?, Error?) -> Void) {
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with:request, completionHandler: completionHandler).resume()
    }
    
    
    
}

