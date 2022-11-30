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
                    
                    cell.okButton.rx.tap
                        .flatMap { a in
                            guard let newNickname = cell.nicknameTextField.text else {
                                return Observable<Bool>.empty()
                            }
                            debugPrint("입력된 아이디 : ", newNickname)
                            return self.viewModel.changeNickname(to: newNickname)
                        }
                        .subscribe(onNext: { result in
                            debugPrint("viewModel 메서드 실행 결과 : ", result)
                        })
                        .disposed(by: self.disposeBag)
                    
                    return cell
                case .settingsSwitch(let title, let isOn):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell") as? SettingsSwitchCell,
                          let action = CellActions(rawValue: row),
                          let self = self else { return UITableViewCell() }
                    
                    cell.switchButton.rx.controlEvent(.touchUpInside)
                        .subscribe(onNext: {
                            let isOn = cell.switchButton.isOn
                            switch action {
                            case .autoplay:
                                self.viewModel.changeAutoPlayMode(to: isOn)
                            default:
                                break
                            }
                        })
                        .disposed(by: self.disposeBag)
                    
                    cell.configure(title: title, isOn: isOn, action: action)
                    return cell
                case .settingsActionSheet(let title):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsActionSheetCell") as? SettingsActionSheetCell else {
                        return UITableViewCell()
                    }
                    
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
                    let actionSheet = UIAlertController(title: "다크 모드 설정", message: nil, preferredStyle: .actionSheet)
                    actionSheet.addAction(UIAlertAction(title: "시스템 설정", style: .default, handler: { _ in
                        self?.viewModel.changeDarkMode(to: 0)
                    }))
                    actionSheet.addAction(UIAlertAction(title: "항상 밝게", style: .default, handler: { _ in
                        self?.viewModel.changeDarkMode(to: 1)
                    }))
                    actionSheet.addAction(UIAlertAction(title: "항상 어둡게", style: .default, handler: { _ in
                        self?.viewModel.changeDarkMode(to: 2)
                    }))
                    self?.present(actionSheet, animated: true)
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
