//
//  SettingsCellModel.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/29.
//

enum SettingsCellModel {
    case nickname
    case settingsSwitch(title: String, isOn: Bool)
    case settingsActionSheet(title: String)
}
