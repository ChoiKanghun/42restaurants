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
    
    // 아래 두 함수는 이미지 pinch zoom 허용 함수.
    func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
      }

    @objc private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
    
    
}
