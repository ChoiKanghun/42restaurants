//
//  PickCoordinateViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/20.
//

import UIKit
import NMapsMap

class PickCoordinateViewController: UIViewController {

    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var mapView: NMFMapView!
    
    var naverCoordinate = NMGLatLng()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.startUpdatingLocation() // 안해주면 위치 안 받아옴.

        return manager
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.touchDelegate = self
    }
    
    @IBAction func touchUpCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpSubmitButton(_ sender: Any) {
        if self.coordinateLabel?.text == "위, 경도 좌표" {
            self.showBasicAlert(title: "좌표를 입력하세요", message: "좌표값은 필수입니다. 지도에서 가게의 위치를 클릭하세요.")
            return
        }
        
        NotificationCenter.default.post(
            name: Notification.Name("TouchedLatLng"),
            object: nil,
            userInfo: ["naverCoordinate": self.naverCoordinate])
        
        self.dismiss(animated: true, completion: nil)
        
    }
}

extension PickCoordinateViewController: CLLocationManagerDelegate {
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.first
        else {return}
        
        let NMGCurrentLocation =
            NMGLatLng(lat: location.coordinate.latitude,
                      lng: location.coordinate.longitude)
        
        let cameraPosition = NMGCurrentLocation
        let cameraUpdate = NMFCameraUpdate(scrollTo: cameraPosition)
        mapView.moveCamera(cameraUpdate)
        
        print("location: \(NMGCurrentLocation)")
        let userMarker = NMFMarker()
        userMarker.position = NMGCurrentLocation
        userMarker.captionText = "ME"
        if let userLocationImage = UIImage(systemName: "circle.fill") {
            let overlayImage = NMFOverlayImage.init(image: userLocationImage)
            userMarker.iconImage = overlayImage
        }
        userMarker.iconTintColor = UIColor.systemRed
        
        userMarker.mapView = mapView

        
        self.locationManager.stopUpdatingLocation()

    }
}

extension PickCoordinateViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        
        let locationOverlay = self.mapView.locationOverlay
        locationOverlay.hidden = false
        locationOverlay.location = latlng
        guard let storeLocationImage = UIImage(named: "pickCoordinateLocationImage.png")
        else { fatalError("can't find image")}
        let locationOverlayImage = NMFOverlayImage.init(image: storeLocationImage)
        
        locationOverlay.icon = locationOverlayImage
        locationOverlay.iconWidth = 24
        locationOverlay.iconHeight = 24
        
        
        self.naverCoordinate = latlng
        
        DispatchQueue.main.async {
            self.coordinateLabel?.text
                = "좌표: \(latlng.lat) | \(latlng.lng)"
        }
    }
}
