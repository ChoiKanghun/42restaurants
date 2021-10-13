//
//  MyInfoViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/06.
//

import UIKit
import AuthenticationServices
import FirebaseAuth

class MyInfoViewController: UIViewController {

    @IBOutlet weak var loginLogoutButton: UIButton!
    @IBOutlet weak var isLoggedInLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear(_:)), name: FirebaseAuthenticationNotification.signInSuccess.notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear(_:)), name: FirebaseAuthenticationNotification.signOutSuccess.notificationName, object: nil)
        
        self.setUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setStatusBarBackgroundColor()
        self.setNavigationBarHidden(isHidden: true)
        self.isLoggedInLabel.textColor = .black
        self.view.backgroundColor = .white
        
    }
    
    private func setUI() {
        DispatchQueue.main.async {
            if let currentUser = Auth.auth().currentUser {
                self.loginLogoutButton.setTitle("로그아웃 >", for: .normal)
                self.isLoggedInLabel.text = "\(currentUser.email ?? "hidden email")"
            } else {
                self.loginLogoutButton.setTitle("로그인", for: .normal)
                self.isLoggedInLabel.text = "로그인이 필요합니다."
            }
        }
    }
    


    @IBAction func touchUpLogOutButton(_ sender: Any) {
       
        if Auth.auth().currentUser != nil {
            FirebaseAuthentication.shared.signOut()
        } else {
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LogInViewController")
            self.present(loginViewController, animated: true, completion: nil)
            
        }
    
    }
}
