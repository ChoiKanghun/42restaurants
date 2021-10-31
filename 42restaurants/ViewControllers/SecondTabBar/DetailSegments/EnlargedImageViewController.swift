//
//  EnlargedImageViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/14.
//

import UIKit
import FirebaseStorage
import FirebaseUI

class EnlargedImageViewController: UIViewController {

    @IBOutlet weak var enlargedImageView: UIImageView!
    
    var imageUrl: String = ""
    let storageRef = Storage.storage().reference()
    
    override func viewDidLoad() {
    
        super.viewDidLoad()

        let imageReference = self.storageRef.child(imageUrl)
        self.enlargedImageView.sd_setImage(with: imageReference)
        self.enlargedImageView.enableZoom()
        self.view.backgroundColor = .black
        
    }
    
    @IBAction func touchUpXButton(_ sender: Any) {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
      
        
    }
    
    
}
