//
//  UIViewController+Extensions.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/20.
//

import Foundation
import UIKit

extension UIViewController {
    func showBasicAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
