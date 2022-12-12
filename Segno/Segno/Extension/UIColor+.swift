//
//  UIColor+.swift
//  Segno
//
//  Created by TaehoYoo on 2022/11/14.
//

import UIKit

enum SColor: String {
    case color1
    case color2
    case color3
    case color4
    
    case background
    case white
    case grey1
    case grey2
    case grey3
    case black
    case label
}

extension UIColor {
    static func appColor(_ name: SColor) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
}
