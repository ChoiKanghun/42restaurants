//
//  UIViewController+Extensions.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/20.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setNavigationBarHidden(isHidden: Bool) {
        if let navigationController = self.navigationController {
            navigationController.isNavigationBarHidden = isHidden
        }
    }
    
    func setStatusBarBackgroundColor() {
        if let statusBarView = statusBarView {
            statusBarView.backgroundColor = Config.shared.applicationThemeColor
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
}
