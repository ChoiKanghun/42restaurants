//
//  EnlargedImageViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/14.
//

import UIKit

class EnlargedImageViewController: UIViewController {

    @IBOutlet weak var UIButtonWithImage: UIButton!
    
    var imagePassed: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIButtonWithImage.imageView?.contentMode = .scaleAspectFit
        UIButtonWithImage.setImage(imagePassed, for: .normal)
        
        self.view.backgroundColor = .black
        
    }
    
    @IBAction func touchUpUIButtonWithImage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
