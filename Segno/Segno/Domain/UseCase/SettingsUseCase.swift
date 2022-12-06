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
    func changeDarkMode(to mode: Int) -> Single<Int>
}

final class SettingsUseCaseImpl: SettingsUseCase {
    let repository: LocalUtilityRepository
    private let disposeBag = DisposeBag()
    
    init(repository: LocalUtilityRepository = LocalUtilityRepositoryImpl()) {
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
        if let mode = repository.getUserDefaultsObject(forKey: .darkmode) as? Int {
            debugPrint("SettingsUseCase - getDarkMode : 키가 있습니다 - \(mode)")
            return mode
        } else {
            repository.setUserDefaults(DarkMode.system.rawValue, forKey: .darkmode)
            debugPrint("SettingsUseCase - getDarkMode : 키가 없어 \(DarkMode.system.rawValue) 로 설정합니다.")
            return DarkMode.system.rawValue
        }
    }
    
    func changeDarkMode(to mode: Int) -> Single<Int> {
        repository.setUserDefaults(mode, forKey: .darkmode)
        debugPrint("SettingsUseCase - changeDarkMode : \(mode)로 설정")
        return Single.create { observer in
            observer(.success(mode))
            return Disposables.create()
        }
    }
}
