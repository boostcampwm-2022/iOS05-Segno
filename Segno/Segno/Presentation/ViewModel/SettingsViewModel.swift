//
//  SettingsViewModel.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/29.
//

import Foundation

import RxSwift

final class SettingsViewModel {
    let dataSource = Observable<[SettingsCellModel]>.just([
        .nickname,
        .settingsSwitch(title: "음악 자동 재생", isOn: true), // TODO: isOn은 로컬 디비로부터 불러와야 합니다.
        .settingsActionSheet(title: "다크 모드")
    ])
    
    init() {
        
    }
}
