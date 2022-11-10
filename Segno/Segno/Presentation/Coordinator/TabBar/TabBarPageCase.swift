//
//  TabBarPageCase.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

enum TabBarPageCase: CaseIterable {
    case diary
    case mypage
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .diary
        case 1:
            self = .mypage
        default:
            return nil
        }
    }
    
    var pageOrderNumber: Int {
        switch self {
        case .diary:
            return 0
        case .mypage:
            return 1
        }
    }
    
    var pageTitle: String {
        switch self {
        case .diary:
            return "Diary"
        case .mypage:
            return "My Page"
        }
    }
    
    var tabIconName: String {
        switch self {
        case .diary:
            return "film"
        case .mypage:
            return "person.fill"
        }
    }
}
