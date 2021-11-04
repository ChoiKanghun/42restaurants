//
//  ModifyMyStoreViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/11/03.
//

import UIKit
import Firebase
import NMapsMap

class ModifyMyStoreViewController: UIViewController {
    static let storyboardIdentifier: String = "modifyMyStoreViewController"
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var modifyBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var changeAddressButton: UIButton!
    @IBOutlet weak var basicAddressLabel: UILabel!
    @IBOutlet weak var detailAddressLabel: UILabel!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var currentCategoryLabel: UILabel!
    @IBOutlet weak var changeCategoryPickerView: UIPickerView!
    
    
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    var pickerValue: String?
    
    var naverCoordinate: NMGLatLng?
    
    var storeData: Store?
    var store: Store? {
        didSet {
            self.storeNameTextField?.text = store?.storeInfo.name
            self.basicAddressLabel?.text = store?.storeInfo.address
            self.detailAddressLabel?.text = store?.storeInfo.addressDetail
            self.currentCategoryLabel?.text = store?.storeInfo.category
            self.telephoneTextField?.text = store?.storeInfo.telephone
        }
    }
    
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
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissIfNotLoggedIn()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnTouchAnywhere)))
        initializeImagePicker()
        initializeCategoryPickerView()
        self.ref = Database.database(url: "https://restaurants-e62b0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        setStore(self.storeData)
        setUI()
        disableModifying()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveModifyAddressNotification(_:)),
                                               name: Notification.Name("ModifyAddressNotification"), object: nil)
    }
    
    private func setUI() {
        setImageView()
        setStoreNameTextFieldUI()
    }
    
    private func setStoreNameTextFieldUI() {
        let borderColor: CGColor = UIColor.gray.cgColor
        
        self.storeNameTextField.layer.borderWidth = 0.5
        self.storeNameTextField.layer.borderColor = borderColor
        self.telephoneTextField.layer.borderWidth = 0.5
        self.telephoneTextField.layer.borderColor = borderColor
    }
    
    
    @objc func dismissKeyboardOnTouchAnywhere() {
        view.endEditing(true)
    }

    private func enableModifying() {
        self.modifyBarButtonItem.title = "저장하기"
        self.changeImageButton.isHidden = false
        self.changeAddressButton.isHidden = false
        self.storeNameTextField.isUserInteractionEnabled = true
        self.changeCategoryPickerView.isHidden = false
    }
    
    private func disableModifying() {
        self.modifyBarButtonItem.title = "수정하기"
        self.changeImageButton.isHidden = true
        self.changeAddressButton.isHidden = true
        self.storeNameTextField.isUserInteractionEnabled = false
        self.changeCategoryPickerView.isHidden = true
    }
    
    private func setImageView() {
        guard let store = store else { return }
        let reference = self.storageRef.child(store.storeInfo.mainImage)
        self.mainImageView.sd_setImage(with: reference)
    }
    
    @objc func didReceiveModifyAddressNotification(_ noti: Notification) {
        guard let basicAddress = noti.userInfo?["basicAddress"] as? String,
              let detailAddress = noti.userInfo?["detailAddress"] as? String,
              let naverCoordinate = noti.userInfo?["naverCoordinate"] as? NMGLatLng
        else { return }
        
        self.basicAddressLabel?.text = basicAddress
        self.detailAddressLabel?.text = detailAddress
        self.naverCoordinate = naverCoordinate
    }

    @IBAction func touchUpChangeImageButton(_ sender: Any) {
        self.present(self.imagePicker, animated: true)
    }

    @IBAction func touchUpModifyBarButtonItem(_ sender: UIBarButtonItem) {
        if self.modifyBarButtonItem.title == "수정하기" {
            self.enableModifying()
            return
        }
        
        guard let storeBeforeChanged = self.store,
              let storeName = self.storeNameTextField.text,
              let telephone = self.telephoneTextField.text,
              let mainImage = self.mainImageView.image
        else { self.showBasicAlert(title: "에러", message: "값을 가져오는 도중 에러 발생."); return }
        LoadingService.showLoading()
        let category = self.pickerValue ?? storeBeforeChanged.storeInfo.category
        let address = self.naverCoordinate == nil ?
            storeBeforeChanged.storeInfo.address : self.basicAddressLabel.text
        let addressDetail = self.naverCoordinate == nil ?
            storeBeforeChanged.storeInfo.addressDetail : self.detailAddressLabel.text
        if storeName == "" { self.showBasicAlert(title: "오류", message: "가게이름은 필수입니다."); return}
        
        let latitude = self.naverCoordinate == nil ? storeBeforeChanged.storeInfo.latitude : self.naverCoordinate?.lat
        let longitude = self.naverCoordinate == nil ? storeBeforeChanged.storeInfo.longtitude : self.naverCoordinate?.lng
        let modifyDate = Date().toDouble()
        
        guard let uploadImageData: Data = mainImage.jpegData(compressionQuality: 0.8)
        else { self.showBasicAlert(title: "실패", message: "이미지를 가져올 수 없습니다."); return }
        let now = Date()
        
        let filePath = "images/\(storeBeforeChanged.storeKey)/\(storeBeforeChanged.storeInfo.enrollUser)\(now.toString()).png"
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        self.storageRef.child(filePath).putData(uploadImageData, metadata: metaData) { [self] (metaData, error) in
            if let error = error {
                self.showBasicAlert(title: "실패", message: "이미지 업로드 도중 에러가 발생하였습니다: \(error)")
                return
            }
            var childUpdates: [String: Any] = [:]
            
            // 메인 이미지 경로 바꾸기.
            childUpdates["stores/\(storeBeforeChanged.storeKey)/mainImage"] = filePath
            
            // 기존의 이미지 정보는 지우기.
            for image in storeBeforeChanged.storeInfo.images {
                // 현재 이미지에 대해 새로운 이미지 정보로 바꿔줌.
                if image.value.imageUrl == storeBeforeChanged.storeInfo.mainImage {
                    childUpdates["stores/\(storeBeforeChanged.storeKey)/images/\(image.key)"] = [
                        "imageUrl": filePath,
                        "createDate": image.value.createDate,
                        "modifyDate": modifyDate ]
                }
            }
            
            for comment in storeBeforeChanged.storeInfo.comments {
                if let commentImage = comment.value.images,
                   let commentImageUrl = commentImage.first?.value.imageUrl,
                   let commentImageKey = commentImage.first?.key,
                   commentImageUrl == storeBeforeChanged.storeInfo.mainImage {
                    childUpdates["stores/\(storeBeforeChanged.storeKey)/comments/\(comment.key)/images/\(commentImageKey)"]
                        = [
                            "createDate": comment.value.createDate,
                            "modifyDate": modifyDate,
                            "imageUrl": filePath ]
                }
            }
            
            childUpdates["stores/\(storeBeforeChanged.storeKey)/name"] = storeName
            childUpdates["stores/\(storeBeforeChanged.storeKey)/latitude"] = latitude ?? 0.0
            childUpdates["stores/\(storeBeforeChanged.storeKey)/longtitude"] = longitude ?? 0.0
            childUpdates["stores/\(storeBeforeChanged.storeKey)/modifyDate"] = modifyDate
            childUpdates["stores/\(storeBeforeChanged.storeKey)/category"] = category
            childUpdates["stores/\(storeBeforeChanged.storeKey)/telephone"] = telephone
            childUpdates["stores/\(storeBeforeChanged.storeKey)/address"] = address ?? ""
            childUpdates["stores/\(storeBeforeChanged.storeKey)/addressDetail"] = addressDetail ?? ""
            
            self.ref.updateChildValues(childUpdates) { error, referenceAfterUpload in
                if let error = error {
                    showBasicAlert(title: "에러", message: "수정도중 에러가 발생하였습니다: \(error.localizedDescription)")
                    return
                }
                // 기존의 이미지는 Storage에서 삭제.
                self.storageRef.child(storeBeforeChanged.storeInfo.mainImage).delete { error in
                    if let error = error {
                        showBasicAlert(title: "에러",
                                       message: "모든 수정 사항이 반영되었으나 storage에서 기존 이미지가 삭제되지 않음.")
                        print("error while deleting image from storage: \(error.localizedDescription)")
                        return
                    }
                    self.showBasicAlertAndHandleCompletion(title: "성공 !", message: "수정사항이 반영되었습니다.") {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: false)
                        }
                    }
                }
            }
        }
  
    }
    
    func setStore(_ store: Store?) {
        guard let store = self.storeData
        else { print("can't get store"); return }
        self.store = store
    }
    
    @IBAction func touchUpCancelButton(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

// MARK: imagePicker 관련
extension ModifyMyStoreViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func initializeImagePicker() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage?
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        self.mainImageView?.image = newImage
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: changeCategory 관련
extension ModifyMyStoreViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    private func initializeCategoryPickerView() {
        self.changeCategoryPickerView.delegate = self
        self.changeCategoryPickerView.dataSource = self
    }
    
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
        self.currentCategoryLabel.text = self.pickerValues[row]
        self.pickerValue = self.pickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: self.pickerValues[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return attributedString
    }
}
