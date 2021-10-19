//
//  UIViewController+Extensions.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/20.
//

import Foundation
import UIKit

extension UIViewController {
    
    // 네비게이션 바를 보이게 하거나 없어지게 합니다.
    func setNavigationBarHidden(isHidden: Bool) {
        if let navigationController = self.navigationController {
            navigationController.isNavigationBarHidden = isHidden
        }
    }
    
    // statusBar 백그라운드 컬러를 설정.
    func setStatusBarBackgroundColor() {
        if let statusBarView = statusBarView {
            DispatchQueue.main.async {
                statusBarView.backgroundColor = Config.shared.application30Color
            }
        }
    }
    
    // navigationBar 백그라운드 컬러 설정
    func setNavigationBarBackgroundColor() {
        if let navigationBar = navigationController?.navigationBar {
            DispatchQueue.main.async {
                navigationBar.barTintColor = Config.shared.application30Color
            }
        }
    }
    
    
    
    
    
    // 상태창 스타일 설정
    var statusBarView: UIView? {
            if #available(iOS 13.0, *) {
                let statusBarFrame = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame
                if let statusBarFrame = statusBarFrame {
                    let statusBar = UIView(frame: statusBarFrame)
                    view.addSubview(statusBar)
                    return statusBar
                } else {
                    return nil
                }
            } else {
                return UIApplication.shared.value(forKey: "statusBar") as? UIView
            }
        }
    
    
    // 경고창 (기본)
    func showBasicAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {_ in 
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showBasicAlertAndHandleCompletion(title: String, message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {_ in
        })
        alert.addAction(okAction)
        self.present(alert, animated: false, completion: completion)
    }
}
