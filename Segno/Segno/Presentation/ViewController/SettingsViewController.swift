//
//  SettingsViewController.swift
//  Segno
//
//  Created by 이예준 on 2022/11/24.
//

import UIKit

import RxCocoa
import RxSwift

enum CellActions: Int {
    case nickname
    case autoplay
    case darkmode
    
    var toRow: Int {
        return self.rawValue
    }
}

final class SettingsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: SettingsViewModel
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NicknameCell.self, forCellReuseIdentifier: "NicknameCell")
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "SettingsSwitchCell")
        tableView.register(SettingsActionSheetCell.self, forCellReuseIdentifier: "SettingsActionSheetCell")
        return tableView
    }()
    
    init(viewModel: SettingsViewModel = SettingsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        bindTableView()
        bind()
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

    private func bindTableView() {
        viewModel.dataSource
            .bind(to: tableView.rx.items) { [weak self] (tableView, row, element) in
                switch element {
                case .nickname:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "NicknameCell") as? NicknameCell,
                          let self = self else { return UITableViewCell() }
                    
                    cell.nicknameChangeButtonTapped
                        .flatMap { nickname in
                            self.viewModel.changeNickname(to: nickname)
                        }
                        .subscribe(onNext: { result in
                            // TODO: result 결과에 따른 Alert 작성
                            debugPrint("viewModel 메서드 실행 결과 : ", result)
                        })
                        .disposed(by: self.disposeBag)
                    return cell
                case .settingsSwitch(let title, let isOn):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell") as? SettingsSwitchCell,
                          let action = CellActions(rawValue: row),
                          let self = self else { return UITableViewCell() }
                    
                    cell.settingsSwitchTapped
                        .subscribe(onNext: { (cellActions, value) in
                            switch cellActions {
                            case .autoplay:
                                guard let value = value as? Bool else { return }
                                return self.viewModel.changeAutoPlayMode(to: value)
                            default:
                                break
                            }
                        })
                        .disposed(by: self.disposeBag)
                    
                    cell.configure(title: title, isOn: isOn, action: action)
                    return cell
                case .settingsActionSheet(let title):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsActionSheetCell") as? SettingsActionSheetCell,
                          let self = self else { return UITableViewCell() }
                    
                    cell.settingsActionSheetTapped
                        .subscribe(onNext: { (actionSheetMode, value) in
                            switch actionSheetMode {
                            case .darkmode:
                                guard let status = value as? Int else { return }
                                self.viewModel.changeDarkMode(to: status)
                            }
                        })
                        .disposed(by: self.disposeBag)
                    
                    cell.configure(title: title)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                guard let action = CellActions(rawValue: indexPath.row) else { return }
                switch action {
                case .darkmode: // 다크 모드 설정
                    guard let cell = self?.tableView.cellForRow(at: indexPath) as? SettingsActionSheetCell else { return }
                    cell.tapped(mode: .darkmode) { alertController in
                        self?.present(alertController, animated: true)
                    }
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        
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
