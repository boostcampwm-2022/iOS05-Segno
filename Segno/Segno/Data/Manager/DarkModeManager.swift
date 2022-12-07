//
//  DarkModeManager.swift
//  Segno
//
//  Created by YOONJONG on 2022/12/06.
//

import UIKit

import RxSwift

class DarkModeManager {
    static let shared = DarkModeManager()
    
    let repository: LocalUtilityRepository
    
    private init() {
        self.repository = LocalUtilityRepositoryImpl()
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
    
    func changeDarkMode(to mode: Int) {
        repository.setUserDefaults(mode, forKey: .darkmode)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: mode) ?? .unspecified
        debugPrint("SettingsUseCase - changeDarkMode : \(mode)로 설정")
        
    }
}
