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

    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onLogOut),
                                               name: FirebaseAuthenticationNotification.signOutSuccess.notificationName,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveDidEnrollStoreNotification(_:)),
                                               name: Notification.Name("didEnrollStore"),
                                               object: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setStatusBarBackgroundColor()
        self.setNavigationBarHidden(isHidden: true)
        self.view.backgroundColor = .white
        self.setNavigationBarBackgroundColor()
    }
    
    @objc func onLogOut() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            exit(0)
        })
    }
    
    @objc func didReceiveDidEnrollStoreNotification(_ noti: Notification) {
        self.showBasicAlert(title: "가게 등록 성공", message: "가게 등록이 완료되었습니다 !")
    }

    @IBAction func touchUpLogOutButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { _ in
            FirebaseAuthentication.shared.signOut()
        })
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: false, completion: nil)

    }
}
