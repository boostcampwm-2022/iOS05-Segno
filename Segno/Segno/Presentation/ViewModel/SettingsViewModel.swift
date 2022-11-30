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
    
    private let useCase: SettingsUseCase
    
    init(useCase: SettingsUseCase = SettingsUseCaseImpl()) {
        self.useCase = useCase
    }
    
    func changeNickname(to nickname: String) -> Observable<Bool> {
        return Observable.create { emitter in
            let result = self.useCase.requestChangeNickname(to: nickname)
            emitter.onNext(result)
            return Disposables.create()
        }
    }
    
    func getAutoPlayMode() -> Bool {
         return useCase.getAutoPlayMode()
    }
    
    func changeAutoPlayMode(to mode: Bool) {
        useCase.changeAutoPlayMode(to: mode)
    }
    
    func getDarkMode() -> Int {
        return useCase.getDarkMode()
    }
    
    func changeDarkMode(to mode: Int) {
        useCase.changeDarkMode(to: mode)
    }
}
