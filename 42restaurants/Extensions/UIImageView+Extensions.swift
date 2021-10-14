//
//  UIImageView+Extensions.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/14.
//

import UIKit

extension UIImageView {

    func addTouchUpEvent(_ targetVC: UIViewController, _ willBeExecuted: Selector) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: targetVC, action: willBeExecuted)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
}
