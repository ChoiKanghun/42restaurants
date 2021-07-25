//
//  EnrollStoreViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/20.
//

import UIKit
import Firebase
import NMapsMap

class EnrollStoreViewController: UIViewController {

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UITextField!
    
    var ref: DatabaseReference!
    
    let storage = Storage.storage()

    let imagePicker = UIImagePickerController()
    
    var selectedCategory = Category.koreanAsian.rawValue
    var naverCoordinate: NMGLatLng?
    
    private let pickerValues: [String]
        = [Category.koreanAsian.rawValue,
           Category.chinese.rawValue,
           Category.japaneseCutlet.rawValue,
           Category.mexican.rawValue,
           Category.western.rawValue,
           Category.meat.rawValue,
           Category.bunsik.rawValue,
           Category.cafe.rawValue,
           Category.fastFood.rawValue,
           Category.chickenPizza.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database(url: "https://restaurants-e62b0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        initializeImagePicker()
        initializeCategoryPickerView()
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didReceiveTouchedLatLngNotification(_:)),
            name: Notification.Name("TouchedLatLng"), object: nil)
    }
    
    func initializeImagePicker() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
    }
    
    func initializeCategoryPickerView() {
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
    }
    
    @objc func didReceiveTouchedLatLngNotification(_ noti: Notification) {
        guard let coordinate = noti.userInfo?["naverCoordinate"] as? NMGLatLng
        else { return }
        
        self.latitudeLabel?.text = "\(coordinate.lat)"
        self.longtitudeLabel?.text = "\(coordinate.lng)"
        
        self.naverCoordinate = coordinate
    }
    
    
    @IBAction func touchUpImageView(_ sender: Any) {
        self.present(self.imagePicker, animated: true)

    }
    
    
    @IBAction func touchUpEnrollButton(_ sender: Any) {
        
        if self.imageView?.image == nil {
            self.showBasicAlert(title: "이미지를 선택해주세요", message: "이미지 선택은 필수입니다.")
            return
        } else if self.storeNameTextField?.text == "" {
            self.showBasicAlert(title: "가게 이름을 입력하세요", message: "가게 이름 입력값은 필수입니다.")
            return
        } else if self.latitudeLabel?.text == "위치 선택 시 자동 입력" {
            self.showBasicAlert(title: "가게 위치를 선택해주세요", message: "'클릭하여 가게 위치 선택' 버튼을 클릭하여 좌표를 선택합니다.")
            return
        }
        
        let location = CLLocation.init(
            latitude: self.naverCoordinate?.lat ?? 0,
            longitude: self.naverCoordinate?.lng ?? 0)
        
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        var addressString = ""
        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { address, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let address = address {
                addressString +=
                    "\(address.last?.administrativeArea ?? "") " +
                    "\(address.last?.locality ?? "") " +
                    "\(address.last?.subLocality ?? "")"
            }
        }
        
        
        guard let uploadImageData = self.imageView.image?.jpegData(compressionQuality: 0.8)
        else {return}
        var data = Data()
        data = uploadImageData
        let now = Date()
        let filePath = "images/\(self.userIdLabel.text ?? "userID")\(now.toString()).png"
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        self.storage.reference().child(filePath).putData(data, metadata: metaData) { [self] (metadata, error) in
            if let error = error {
                print(error.localizedDescription)
                self.showBasicAlert(title: "에러", message: "알 수 없는 오류가 발생하여 업로드에 실패하였습니다.")
                return
            }
            
            guard let key = self.ref.child("stores").childByAutoId().key
            else { return }
            
            let store =
                ["name": self.storeNameTextField.text ?? "noname",
                 "latitude": (self.naverCoordinate?.lat ?? 0.0),
                 "longtitude": (self.naverCoordinate?.lng ?? 0.0),
                 "rating": 0.0,
                 "image": filePath,
                 "enrollUser": (self.userIdLabel.text ?? ""),
                 "createDate": now.toDouble(),
                 "modifyDate": now.toDouble(),
                 "category": self.selectedCategory,
                 "telephone": (self.telephoneLabel.text ?? ""),
                 "address": addressString 
                ] as [String : Any]
            
            let childUpdates = ["stores/\(key)": store]
            self.ref.updateChildValues(childUpdates)
            
        }
    }
    
    

}

extension EnrollStoreViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage?
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        self.imageView?.image = newImage
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
}


extension EnrollStoreViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
       return self.pickerValues[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCategory = self.pickerValues[row]
    }
}
