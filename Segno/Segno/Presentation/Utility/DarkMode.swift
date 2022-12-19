//
//  DarkMode.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/30.
//

enum DarkMode: Int, CaseIterable {
    case system
    case light
    case dark
    
    var title: String {
        switch self {
        case .system:
            return "시스템 설정"
        case .light:
            return "항상 밝게"
        case .dark:
            return "항상 어둡게"
        }
    }
}
