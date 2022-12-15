//
//  Location.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/24.
//

import Foundation
import CoreLocation

struct Location: Codable, Equatable {
    let latitude: Double
    let longitude: Double
    
    func createCLLocation() -> CLLocation {
        CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}
