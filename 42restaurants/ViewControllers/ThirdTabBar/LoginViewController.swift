//
//  LoginViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/06.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissThisView), name: FirebaseAuthenticationNotification.signInSuccess.notificationName, object: nil)
        
    }
    
    
    
    @objc func dismissThisView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpSignInWithApple(_ sender: Any) {
        guard let window = UIApplication.shared.windows.last else { print("cant get window");return }
        FirebaseAuthentication.shared.signInWithApple(window: window)
    }
    

}

