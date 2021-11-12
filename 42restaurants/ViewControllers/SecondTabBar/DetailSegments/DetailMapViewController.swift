//
//  DetailMapViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/29.
//

import UIKit
import NMapsMap
import Firebase

class DetailMapViewController: UIViewController {

    @IBOutlet weak var mapView: NMFMapView!
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.startUpdatingLocation() // 안해주면 위치 안 받아옴.

        return manager
    }()
    
    let storeMarker = NMFMarker()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.positionMode = .normal
        
        ref = Database.database(url: Config.shared.referenceAddress).reference()
    
        if let tabBarIndex = self.tabBarController?.selectedIndex,
           let storeInfo = tabBarIndex == 0 ? MainTabStoreSingleton.shared.store?.storeInfo : StoreSingleton.shared.store?.storeInfo {
            let location = CLLocationCoordinate2DMake(
                storeInfo.latitude,
                storeInfo.longtitude)
            
            moveCameraToStoreLocation(location)
        } else {
            print (" can't get store location")
        }
    }
    


}

extension DetailMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            
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
    
    func moveCameraToStoreLocation(_ coordinate: CLLocationCoordinate2D) {
        let NMGStoreLocation = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        let cameraPosition = NMGStoreLocation
        let cameraUpdate = NMFCameraUpdate(scrollTo: cameraPosition)
        mapView.moveCamera(cameraUpdate)
        
        storeMarker.position = NMGStoreLocation
        storeMarker.captionText = "HERE"
        if let userLocationImage = UIImage(systemName: "mappin.and.ellipse") {
            let overlayImage = NMFOverlayImage.init(image: userLocationImage)
            storeMarker.iconImage = overlayImage
        }
        storeMarker.width = 40
        storeMarker.height = 40
        storeMarker.iconTintColor = UIColor.systemRed
        storeMarker.mapView = self.mapView
        DispatchQueue.main.async {
            self.mapView.reloadInputViews()
        }
    }
    
}

