//
//  Location.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/24.
//

import Foundation
import CoreLocation

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    
    // TODO: 이 방법이 옳은지 논의를 해봐야합니다.
    func createCLLocation() -> CLLocation {
        CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}
