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
    
    
    var stores = Dictionary<String, Store>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.positionMode = .normal
            
        ref = Database.database(url: "https://restaurants-e62b0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        self.ref.child("stores").getData{ (error, snapshot) in
        
            if let error = error {
                print(error.localizedDescription)
            } else if snapshot.exists() {
                guard let value = snapshot.value else {return}
                do { let store = try FirebaseDecoder().decode(Dictionary<String, Store>.self, from: value)
                    self.stores = store
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

        
        
//        let infoWindow = NMFInfoWindow()
//        let dataSource = NMFInfoWindowDefaultTextSource.data()
//        dataSource.title = "test"
//        infoWindow.dataSource = dataSource
//        infoWindow.open(with: marker)
//


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
        let storageRef = storage.reference()
        let placeholderImage = UIImage(named: "placeholder.jpg")
        
        for (index, element) in self.stores.enumerated() {
            let marker = NMFMarker()
            print(element.value.latitude)
            marker.position = NMGLatLng(
                lat: Double(element.value.latitude),
                lng: Double(element.value.longtitude))
            markers.append(marker)
            marker.width = 40
            marker.height = 40
            let reference = storageRef.child("images/\(element.value.image)")
            DispatchQueue.main.async {
                var tempImageView = UIImageView()
                tempImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
                if let markerImage = tempImageView.image {
                    let overlayImage = NMFOverlayImage.init(image: markerImage)
                    print(reference.fullPath)
                    marker.iconImage = overlayImage
                } else { print (" markerImage get Fail "); print("4")}
                marker.mapView = self.mapView
            }
            if index == self.stores.count - 1 {
                DispatchQueue.main.async {
                    self.mapView.reloadInputViews()
                }
            }
            
        }
        
//        for marker in markers {
//            marker.mapView = self.mapView
//        }
        
        
        
        
    }
}
