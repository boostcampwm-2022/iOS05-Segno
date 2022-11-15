//
//  UIFont+.swift
//  Segno
//
//  Created by TaehoYoo on 2022/11/14.
//

import UIKit

enum SFont {
    case shiningStar
    case surround
    case surroundAir
}

extension UIFont {
    static func appFont(_ name: SFont, size: CGFloat) -> UIFont {
        let defaultFont = UIFont.systemFont(ofSize: size)
        var targetFont: UIFont?
        
        switch name {
        case .shiningStar:
            targetFont = UIFont(name: "Cafe24ShiningStar", size: size)
        case .surround:
            targetFont = UIFont(name: "Cafe24Ssurround", size: size)
        case .surroundAir:
            targetFont = UIFont(name: "Cafe24SsurroundAir", size: size)
        }
        
        return targetFont ?? defaultFont
    }
}
