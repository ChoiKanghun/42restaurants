//
//  EnrollStoreViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/20.
//

import UIKit
import Firebase

class EnrollStoreViewController: UIViewController {

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longtitudeLabel: UILabel!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(),
            name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
    }
    
    
    @IBAction func touchUpEnrollButton(_ sender: Any) {
        guard let key = self.ref.child("stores").childByAutoId().key
        else { return }

        
        
        
    }
    
    

}
