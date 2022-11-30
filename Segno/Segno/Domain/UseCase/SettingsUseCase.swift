//
//  SettingsUseCase.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/30.
//

import RxSwift

protocol SettingsUseCase {
    func requestChangeNickname(to nickname: String) -> Bool
    func getAutoPlayMode() -> Bool
    func changeAutoPlayMode(to mode: Bool)
    func getDarkMode() -> Int
    func changeDarkMode(to mode: Int)
}

final class SettingsUseCaseImpl: SettingsUseCase {
    let repository: LocalUtilityRepository
    private let disposeBag = DisposeBag()
    
    init(repository: LocalUtilityRepository = LocalUtilityRepositoryImpl()) {
        self.repository = repository
    }
    
    func requestChangeNickname(to nickname: String) -> Bool {
        // 임시 처리입니다.
        debugPrint("SettingsUseCase - requestChangeNickname : \(nickname)으로 변경")
        return true
    }
    
    func getAutoPlayMode() -> Bool {
        if let isEnabled = repository.getUserDefaultsObject(forKey: .isAutoPlayEnabled) as? Bool {
            debugPrint("SettingsUseCase - getAutoPlayMode : 키가 있습니다 - \(isEnabled)")
            return isEnabled
        } else {
            repository.setUserDefaults(true, forKey: .isAutoPlayEnabled)
            debugPrint("SettingsUseCase - getAutoPlayMode : 키가 없어 true 로 설정합니다.")
            return true
        }
    }
    
    func changeAutoPlayMode(to mode: Bool) {
        repository.setUserDefaults(mode, forKey: .isAutoPlayEnabled)
        debugPrint("SettingsUseCase - changeAutoPlayMode : \(mode)로 설정")
    }
    
    func getDarkMode() -> Int {
        if let mode = repository.getUserDefaultsObject(forKey: .darkmode) as? Int {
            debugPrint("SettingsUseCase - getDarkMode : 키가 있습니다 - \(mode)")
            return mode
        } else {
            repository.setUserDefaults(0, forKey: .isAutoPlayEnabled)
            debugPrint("SettingsUseCase - getDarkMode : 키가 없어 0 로 설정합니다.")
            return 0
        }
    }
    
    func changeDarkMode(to mode: Int) {
        repository.setUserDefaults(mode, forKey: .isAutoPlayEnabled)
        debugPrint("SettingsUseCase - changeDarkMode : \(mode)로 설정")
    }
}
