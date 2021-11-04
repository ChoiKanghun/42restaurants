//
//  ManageMyStorePickCoordinateViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/11/04.
//

import UIKit
import NMapsMap

class ManageMyStorePickCoordinateViewController: UIViewController {

    @IBOutlet weak var mapView: NMFMapView!
    @IBOutlet weak var basicAddressLabel: UILabel!
    @IBOutlet weak var detailAddressLabel: UILabel!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationBarHidden(isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.setNavigationBarHidden(isHidden: false)
    }
    
    @IBAction func touchUpCancelButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func touchUpSubmitButton(_ sender: Any) {
        if self.basicAddressLabel?.text == "읍/면/동" {
            self.showBasicAlert(title: "좌표를 입력하세요", message: "좌표값은 필수입니다. 지도에서 가게의 위치를 클릭하세요.")
            return
        }
        
        NotificationCenter.default.post(
            name: Notification.Name("ModifyAddressNotification"),
            object: nil,
            userInfo: ["naverCoordinate": self.naverCoordinate,
                       "basicAddress": self.basicAddressLabel.text!,
                       "detailAddress": self.detailAddressLabel.text!])
        
        self.navigationController?.popViewController(animated: true)
        
    }
}


extension ManageMyStorePickCoordinateViewController: CLLocationManagerDelegate {
    
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


extension ManageMyStorePickCoordinateViewController: NMFMapViewTouchDelegate {
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
            self.setCoordinateLabel(latlng)
        }
    }
    
    private func setCoordinateLabel(_ latlng: NMGLatLng) {
        let location = CLLocation(latitude: latlng.lat, longitude: latlng.lng)
        let geoCoder = CLGeocoder()
        let locale: Locale = Locale(identifier: "Ko-kr") // Korea
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) {
            (place, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            var basicAddress: String = ""
            var detailAddress: String = ""
            if let place: [CLPlacemark] = place,
               let address = place.last {
                basicAddress += " \(address.administrativeArea ?? "")"
                basicAddress += " \(address.subAdministrativeArea ?? "")"
                basicAddress += " \(address.locality ?? "")"
                basicAddress += " \(address.subLocality ?? "")"
                detailAddress += " \(address.thoroughfare ?? "")"
                detailAddress += " \(address.subThoroughfare ?? "")"
                
                self.basicAddressLabel.text = basicAddress
                self.detailAddressLabel.text = detailAddress
            }
        }
    }
}

