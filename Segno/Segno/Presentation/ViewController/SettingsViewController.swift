//
//  SettingsViewController.swift
//  Segno
//
//  Created by 이예준 on 2022/11/24.
//

import UIKit

import RxCocoa
import RxSwift

enum SettingsCellActions: Int {
    case nickname
    case autoplay
    case darkmode
    
    var toRow: Int {
        return self.rawValue
    }
}

final class SettingsViewController: UIViewController {
    // MARK: - Namespaces
    private enum Metric {
        static let navigationTitleSize: CGFloat = 20
        static let nicknameCellHeight: CGFloat = 100
        static let otherCellsHeight: CGFloat = 44
        static let separatorInset: CGFloat = 15
    }
    
    private enum Literal {
        static let settingString = "설정"
        static let darkModeSettingString = "다크 모드 설정"
        static let cancelMessage = "취소"
        static let nicknameCellIdentifier = "NicknameCell"
        static let settingsSwitchCellIdentifier = "SettingsSwitchCell"
        static let settingsActionSheetCellIdentifier = "SettingsActionSheetCell"
        static let errorTitle = "오류"
        static let successTitle = "성공"
        static let failureTitle = "실패"
        static let emptyNickname = "닉네임이 비어있습니다."
        static let shorterNickname = "닉네임은 10글자 이하로 작성해주세요."
        static let nicknameChangeSuccess = "닉네임을 변경했습니다."
        static let nicknameChangeFailure = "닉네임 변경에 실패했습니다."
    }
    
    // MARK: - Properties
    private let viewModel: SettingsViewModel
    private var disposeBag = DisposeBag()
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .appColor(.background)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(NicknameCell.self, forCellReuseIdentifier: Literal.nicknameCellIdentifier)
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: Literal.settingsSwitchCellIdentifier)
        tableView.register(SettingsActionSheetCell.self, forCellReuseIdentifier: Literal.settingsActionSheetCellIdentifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left:  Metric.separatorInset, bottom: 0, right:  Metric.separatorInset)
        return tableView
    }()
    
    // MARK: Initializers
    init(viewModel: SettingsViewModel = SettingsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        bindTableView()
    }
    
    // MARK: - Setup view methods
    private func setupView() {
        title = Literal.settingString
        view.backgroundColor = .appColor(.background)
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: Metric.navigationTitleSize, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.appColor(.color4) ?? .red
        ]
        
        tableView.delegate = self
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Bind view methods
    private func bindTableView() {
        viewModel.dataSource
            .bind(to: tableView.rx.items) { [weak self] (tableView, row, element) in
                switch element {
                case .nickname:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: Literal.nicknameCellIdentifier)
                            as? NicknameCell,
                          let self = self else { return UITableViewCell() }
                    
                    cell.okButton.rx.tap
                        .flatMap { _ in
                            guard let newNickname = cell.nicknameTextField.text,
                                  newNickname.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
                                self.makeOKAlert(title: Literal.errorTitle, message: Literal.emptyNickname)
                                cell.nicknameTextField.text = nil
                                return Observable<Bool>.empty()
                            }
                            
                            if newNickname.count > 10 {
                                self.makeOKAlert(title: Literal.errorTitle, message: Literal.shorterNickname)
                                return Observable<Bool>.empty()
                            }
                            
                            return self.viewModel.changeNickname(to: newNickname)
                                .asObservable()
                        }
                        .withUnretained(self)
                        .observe(on: MainScheduler.instance)
                        .subscribe(onNext: { _, result in
                            switch result {
                            case true:
                                cell.nicknameTextField.resignFirstResponder()
                                self.makeOKAlert(title: Literal.successTitle, message: Literal.nicknameChangeSuccess)
                                cell.nicknameTextField.text = nil
                            case false:
                                self.makeOKAlert(title: Literal.failureTitle, message: Literal.nicknameChangeFailure)
                            }
                        })
                        .disposed(by: self.disposeBag)
                    return cell
                case .settingsSwitch(let title, let isOn):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: Literal.settingsSwitchCellIdentifier)
                            as? SettingsSwitchCell,
                          let action = SettingsCellActions(rawValue: row),
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
                case .settingsActionSheet(let title, let mode):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: Literal.settingsActionSheetCellIdentifier)
                            as? SettingsActionSheetCell else { return UITableViewCell() }
                    let darkModeTitle = DarkMode.allCases[mode].title
                    cell.configure(left: title, right: darkModeTitle)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                guard let action = SettingsCellActions(rawValue: indexPath.row) else { return }
                switch action {
                case .darkmode: // 다크 모드 설정
                    guard let cell = self?.tableView.cellForRow(at: indexPath) as? SettingsActionSheetCell,
                          let self = self else { return }
                    let actionSheet = UIAlertController(title: Literal.darkModeSettingString, message: nil, preferredStyle: .actionSheet)
                    actionSheet.addAction(UIAlertAction(title: DarkMode.system.title, style: .default, handler: { _ in
                        self.viewModel.changeDarkMode(to: DarkMode.system.rawValue)
                        cell.configure(right: DarkMode.system.title)
                    }))
                    actionSheet.addAction(UIAlertAction(title: DarkMode.light.title, style: .default, handler: { _ in
                        self.viewModel.changeDarkMode(to: DarkMode.light.rawValue)
                        cell.configure(right: DarkMode.light.title)
                    }))
                    actionSheet.addAction(UIAlertAction(title: DarkMode.dark.title, style: .default, handler: { _ in
                        self.viewModel.changeDarkMode(to: DarkMode.dark.rawValue)
                        cell.configure(right: DarkMode.dark.title)
                    }))
                    actionSheet.addAction(UIAlertAction(title: Literal.cancelMessage
                                                        , style: .cancel, handler: { _ in
                        self.dismiss(animated: true)
                    }))
                    self.present(actionSheet, animated: true)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SettingsViewController: UITableViewDelegate {
    // MARK: - Table view delegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return Metric.nicknameCellHeight
        }
        
        return Metric.otherCellsHeight
    }
}

// MARK: - Preview methods
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct SettingsViewController_Preview: PreviewProvider {
    static var previews: some View {
        SettingsViewController().showPreview(.iPhone14Pro)
    }
}
#endif
