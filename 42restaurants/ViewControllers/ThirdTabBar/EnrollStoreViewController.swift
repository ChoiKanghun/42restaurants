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
    @IBOutlet weak var starRatingSlider: UISlider!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
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
        
        self.starRatingSlider.value = 5.0
        
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
        LoadingService.showLoading()
        if self.imageView?.image == nil {
            self.showBasicAlert(title: "이미지를 선택해주세요", message: "이미지 선택은 필수입니다.")
            LoadingService.hideLoading()
            return
        } else if self.storeNameTextField?.text == "" {
            self.showBasicAlert(title: "가게 이름을 입력하세요", message: "가게 이름 입력값은 필수입니다.")
            LoadingService.hideLoading()
            return
        } else if self.latitudeLabel?.text == "위치 선택 시 자동 입력" {
            self.showBasicAlert(title: "가게 위치를 선택해주세요", message: "'클릭하여 가게 위치 선택' 버튼을 클릭하여 좌표를 선택합니다.")
            LoadingService.hideLoading()
            return
        } else if self.commentTextView?.text == "가게에 대한 평가를 적어주세요." {
            self.showBasicAlert(title: "가게에 대한 평가를 적어주세요", message: "가게평은 필수입니다.")
            LoadingService.hideLoading()
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
                LoadingService.hideLoading()
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
        else {LoadingService.hideLoading(); return}
        var data = Data()
        data = uploadImageData
        let now = Date()
        
        guard let key = self.ref.child("stores").childByAutoId().key
        else { LoadingService.hideLoading();return }
        
        let filePath = "images/\(key)/\(self.userIdLabel.text ?? "userID")\(now.toString()).png"
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        self.storage.reference().child(filePath).putData(data, metadata: metaData) { [self] (metadata, error) in
            if let error = error {
                print(error.localizedDescription)
                LoadingService.hideLoading()
                self.showBasicAlert(title: "에러", message: "알 수 없는 오류가 발생하여 업로드에 실패하였습니다.")
                return
            }
            
            let ratingFloorValue = Double(floor(self.starRatingSlider.value * 10)) / 10
            
            guard let imageKey = self.ref.child("images").childByAutoId().key
            else {
                LoadingService.hideLoading();
                print("can't get imageKey");
                return
            }
            
            
            let store =
                ["name": self.storeNameTextField.text ?? "noname",
                 "latitude": (self.naverCoordinate?.lat ?? 0.0),
                 "longtitude": (self.naverCoordinate?.lng ?? 0.0),
                 "rating": ratingFloorValue,
                 "mainImage": filePath,
                 "enrollUser": (self.userIdLabel.text ?? ""),
                 "createDate": now.toDouble(),
                 "modifyDate": now.toDouble(),
                 "category": self.selectedCategory,
                 "telephone": (self.telephoneLabel.text ?? ""),
                 "address": addressString,
                 "commentCount": 1,
                 "images": [imageKey:
                                ["imageUrl": filePath,
                                 "createDate": now.toDouble(),
                                 "modifyDate": now.toDouble()]]
                ] as [String : Any]
            
            let childUpdates = ["stores/\(key)": store]
            self.ref.updateChildValues(childUpdates) { error, refAfterUpload  in
                
                guard let commentKey = self.ref.child("stores/\(key)/comments").childByAutoId().key
                else {LoadingService.hideLoading();return }
                
                
                let comments = [
                    "rating": ratingFloorValue,
                    "description": self.commentTextView?.text ?? "",
                    "userId": self.userIdLabel?.text ?? "unknown",
                    "images": [imageKey:
                                   ["imageUrl": filePath,
                                    "createDate": now.toDouble(),
                                    "modifyDate": now.toDouble()]],
                    "createDate": Date().toDouble(),
                    "modifyDate": Date().toDouble()
                ] as [String: Any]
                
                let secondChildUpdates = ["stores/\(key)/comments/\(commentKey)": comments]
                refAfterUpload.updateChildValues(secondChildUpdates) {
                    (error, snapshot) in
                    DispatchQueue.main.async {
                        LoadingService.hideLoading()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            }
        }
    }
    
    
    @IBAction func onDragStarSlider(_ sender: UISlider) {
        let floatValue = floor(sender.value * 10) / 10
        
        for index in 1...5 {
            if let starImage = view.viewWithTag(index) as? UIImageView {
                if Float(index) <= floatValue {
                    starImage.image = UIImage(named: "star_full_48px")
                } else if Float(index) - floatValue <= 0.5 {
                    starImage.image = UIImage(named: "star_half_48px")
                } else {
                    starImage.image = UIImage(named: "star_empty_48px")
                }
            }
        }
        DispatchQueue.main.async {
            self.ratingLabel?.text = "\(floatValue)"
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
