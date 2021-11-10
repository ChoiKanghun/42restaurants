//
//  LoginViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/06.
//

import UIKit
import AuthenticationServices
import Firebase
import CodableFirebase

class LoginViewController: UIViewController {

    static let storyboardId = "logInViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutIfBlockedAuthentication()
        logInIfAlreadySignedIn()
        NotificationCenter.default.addObserver(self, selector: #selector(logInIfAlreadySignedIn), name: FirebaseAuthenticationNotification.signInSuccess.notificationName, object: nil)
        
    }
    
    @IBAction func touchUpSignInWithApple(_ sender: Any) {
        guard let window = UIApplication.shared.windows.last else { print("can't get window");return }
        FirebaseAuthentication.shared.signInWithApple(window: window)
    }
    
    private func logOutIfBlockedAuthentication() {
        if FirebaseAuthentication.shared.checkUserExists() == false { return }
        let ref: DatabaseReference! = Database.database(url: "https://restaurants-e62b0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        ref.child("reports/deleted").observe(DataEventType.value, with: { snapshot in
            if let value = snapshot.value {
                do {
                    let currentUserEmail = FirebaseAuthentication.shared.getUserEmail()
                    let deletedUserPairs = try FirebaseDecoder().decode([String: String].self, from: value)
                    for deletedUser in deletedUserPairs.values {
                        if currentUserEmail == deletedUser {
                            FirebaseAuthentication.shared.signOut()
                            self.showBasicAlertAndHandleCompletion(title: "정지된 계정입니다.", message: "애플 아이디로 로그인 기능이 정지됩니다.") {
                                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { exit(0) }
                            }
                        }
                    }
                } catch let e {
                    print(e.localizedDescription)
                }
            }
        })
    }
    
    @objc func logInIfAlreadySignedIn() {
        if FirebaseAuthentication.shared.checkUserExists() == true {
            guard let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") else { return }
            self.navigationController?.pushViewController(mainTabBarController, animated: true)
        }
    }
}

