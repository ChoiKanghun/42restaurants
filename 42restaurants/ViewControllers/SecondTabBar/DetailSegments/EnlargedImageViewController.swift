//
//  EnlargedImageViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/14.
//

import UIKit


class EnlargedImageViewController: UIViewController {

    @IBOutlet weak var enlargedImageView: UIImageView!
    
    var imagePassed: UIImage?
    
    override func viewDidLoad() {
    
        super.viewDidLoad()

        self.enlargedImageView.image = self.imagePassed
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
