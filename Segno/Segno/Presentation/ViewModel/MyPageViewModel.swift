//
//  MyPageViewModel.swift
//  Segno
//
//  Created by 이예준 on 2022/11/29.
//

import UIKit

import RxSwift

enum MyPageCellModel {
    case writtenDiary(title: String, subtitle: String)
    case settings(title: String)
    case logout(title: String, color: UIColor)
}

final class MyPageViewModel {
    let dataSource = Observable<[MyPageCellModel]>.just([
        .writtenDiary(title: "작성한 일기 수", subtitle: "123,456,789개"), // TODO: subtitle 불러오기
        .settings(title: "설정"),
        .logout(title: "logout", color: .red)
    ])
    
    init() {
        
    }
}
