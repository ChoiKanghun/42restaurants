//
//  CLLocationCoordinate2D+Extensions.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/10/20.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return from.distance(from: to)
    }
}
