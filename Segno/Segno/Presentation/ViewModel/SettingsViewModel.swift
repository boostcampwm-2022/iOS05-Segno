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
    
    // TODO: 닉네임 변경 로직
    func changeNickname(to nickname: String) -> Observable<Bool> {
//        return useCase.requestChangeNickname(to: nickname)
        
        // 임시 처리입니다.
        return Observable.create { emitter in
            emitter.onNext(true)
            return Disposables.create()
        }
    }
    
    // TODO: 음악 자동 재생 여부 불러오기 / 클릭 시 반영하기
    func getAutoPlayMode() -> Bool {
        // return useCase.getAutoPlayMode()
        
        // 임시 값입니다.
        return true
    }
    
    func changeAutoPlayMode(to mode: Bool) {
//        useCase.changeAutoPlayMode(to: mode)
    }
    
    // TODO: 다크모드 설정 불러오기 / 액션 시트 선택 시 반영하기
    func getDarkMode() -> Int {
        // return useCase.getDarkMode()
        
        // 임시 값입니다.
        return 0
    }
    
    func changeAutoPlayMode() {
        // TODO: 액션 시트를 띄워야 합니다.
    }
}
