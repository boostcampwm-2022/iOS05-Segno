//
//  SettingsViewModel.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/29.
//

import Foundation

import RxSwift

final class SettingsViewModel {
    lazy var dataSource = Observable<[SettingsCellModel]>.just([
        .nickname,
        .settingsSwitch(title: "음악 자동 재생", isOn: settingsUseCase.getAutoPlayMode()),
        .settingsActionSheet(title: "다크 모드", mode: settingsUseCase.getDarkMode())
    ])
    
    private let settingsUseCase: SettingsUseCase
    private let changeUserNameUseCase: ChangeUserNameUseCase
    
    init(settingsUseCase: SettingsUseCase = SettingsUseCaseImpl(),
         changeUserNameUseCase: ChangeUserNameUseCase = ChangeUserNameUseCaseImpl()
    ) {
        self.settingsUseCase = settingsUseCase
        self.changeUserNameUseCase = changeUserNameUseCase
    }
    
    func changeNickname(to nickname: String) -> Single<Bool> {
        return self.changeUserNameUseCase.requestChangeNickname(to: nickname)
    }
    
    func getAutoPlayMode() -> Bool {
         return settingsUseCase.getAutoPlayMode()
    }
    
    func changeAutoPlayMode(to mode: Bool) {
        settingsUseCase.changeAutoPlayMode(to: mode)
    }
    
    func getDarkMode() -> Int {
        return settingsUseCase.getDarkMode()
    }
    
    func changeDarkMode(to mode: Int) {
        settingsUseCase.changeDarkMode(to: mode)
    }
}
