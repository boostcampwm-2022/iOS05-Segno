//
//  SettingsUseCase.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/30.
//

import RxSwift

protocol SettingsUseCase {
    func getAutoPlayMode() -> Bool
    func changeAutoPlayMode(to mode: Bool)
    func getDarkMode() -> Int
    func changeDarkMode(to mode: Int)
}

final class SettingsUseCaseImpl: SettingsUseCase {
    let repository: LocalUtilityManager
    private var disposeBag = DisposeBag()
    
    init(repository: LocalUtilityManager = LocalUtilityManagerImpl()) {
        self.repository = repository
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
        return DarkModeManager.shared.getDarkMode()
    }
    
    func changeDarkMode(to mode: Int) {
        DarkModeManager.shared.changeDarkMode(to: mode)
    }
}
