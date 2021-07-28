//
//  StarRatingUISlider.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/27.
//

import Foundation
import UIKit

class StarRatingUISlider: UISlider {
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let width = self.frame.size.width
        let tapPoint = touch.location(in: self)
        let fPercent = (tapPoint.x / width)
        let nNewValue = self.maximumValue * Float(fPercent)
        if nNewValue != self.value {
            self.value = nNewValue
        }
        return true
    }
    
}
