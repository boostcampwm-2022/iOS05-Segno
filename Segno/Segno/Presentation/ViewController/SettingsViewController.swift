//
//  SettingsViewController.swift
//  Segno
//
//  Created by 이예준 on 2022/11/24.
//

import UIKit

import RxCocoa
import RxSwift

final class SettingsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NicknameCell.self, forCellReuseIdentifier: "NicknameCell")
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "SettingsSwitchCell")
        tableView.register(SettingsActionSheetCell.self, forCellReuseIdentifier: "SettingsActionSheetCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        bindTableView()
    }
    
    private func setupView() {
        title = "설정"
        view.backgroundColor = .appColor(.background)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SettingsViewController {
    private func bindTableView() {
        let dataSource = Observable<[SettingsCellModel]>.just([
            .nickname,
            .settingsSwitch(title: "음악 자동 재생", isOn: true), // TODO: isOn은 로컬 디비로부터 불러와야 합니다.
            .settingsActionSheet(title: "다크 모드")
        ])
        
        dataSource
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                switch element {
                case .nickname:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "NicknameCell") as? NicknameCell else { return UITableViewCell() }
                    return cell
                case .settingsSwitch(let title, let isOn):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell") as? SettingsSwitchCell else { return UITableViewCell() }
                    cell.configure(title: title, isOn: isOn, row: row)
                    return cell
                case .settingsActionSheet(let title):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsActionSheetCell") as? SettingsActionSheetCell else { return UITableViewCell() }
                    cell.configure(title: title)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                switch indexPath.row {
                case 2: // 다크 모드 설정
                    guard let cell = self?.tableView.cellForRow(at: indexPath) as? SettingsActionSheetCell else { return }
                    cell.tapped(mode: .darkmode)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct SettingsViewController_Preview: PreviewProvider {
    static var previews: some View {
        SettingsViewController().showPreview(.iPhone14Pro)
    }
}
#endif
