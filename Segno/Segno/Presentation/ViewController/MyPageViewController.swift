//
//  MyPageViewController.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

enum MyPageCellActions: Int {
    case diary
    case setting
    case logout
    case resign
    
    var toRow: Int {
        return self.rawValue
    }
}

enum MyPageCellModel {
    case writtenDiary(title: String, subtitle: String)
    case settings(title: String)
    case logout(title: String, color: UIColor)
    case resign(title: String, color: UIColor)
}

protocol MyPageViewDelegate: AnyObject {
    func settingButtonTapped()
    func logoutButtonTapped()
}

final class MyPageViewController: UIViewController {
    // MARK: - Namespaces
    private enum Metric {
        static let settingsOffset: CGFloat = 100
        static let titleFontSize: CGFloat = 32
        static let titleOffset: CGFloat = 30
        static let separatorInset: CGFloat = 15
        static let navigationTitleSize: CGFloat = 20
        static let navigationBackButtonTitleSize: CGFloat = 16
    }
    
    private enum Literal {
        static let checkTitle = "로그인 정보가 없습니다."
        static let checkMessage = "로그인 화면으로 돌아갑니다."
        static let logoutMessage = "정말 로그아웃하시겠습니까?"
        static let logoutTitle = "로그아웃"
        static let resignMessage = "정말 탈퇴하시겠습니까? 지금까지 작성한 글들이 모두 삭제됩니다."
        static let resignTitle = "회원 탈퇴"
        static let confirmResignMessage = "이용해 주셔서 감사합니다."
        static let confirmResignTitle = "회원 탈퇴 완료"
        static let mypageText = "마이페이지"
        static let titleText = "안녕하세요,\nboostcamp님!"
        static let userToken = "userToken"
        static let writtenDiaryCellIdentifier = "writtenDiary"
        static let settingsCellIdentifier = "settings"
        static let logoutCellIdentifier = "logout"
        static let resignCellIdentifier = "resign"
    }
    
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private let viewModel: MyPageViewModel
    private let localUtilityManager: LocalUtilityManager
    weak var mypageDelegate: MyPageViewDelegate?
    
    // MARK: - Views
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: Metric.titleFontSize, weight: .bold)
        label.numberOfLines = 0
        label.text = Literal.titleText
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .appColor(.background)
        tableView.register(SettingsActionSheetCell.self, forCellReuseIdentifier: Literal.writtenDiaryCellIdentifier)
        tableView.register(SettingsActionSheetCell.self, forCellReuseIdentifier: Literal.settingsCellIdentifier)
        tableView.register(SettingsActionSheetCell.self, forCellReuseIdentifier: Literal.logoutCellIdentifier)
        tableView.register(SettingsActionSheetCell.self, forCellReuseIdentifier: Literal.resignCellIdentifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: Metric.separatorInset, bottom: 0, right: Metric.separatorInset)
        return tableView
    }()
    
    // MARK: - Initializers
    init(viewModel: MyPageViewModel = MyPageViewModel(),
         localUtilityManager: LocalUtilityManager = LocalUtilityManagerImpl()) {
        self.viewModel = MyPageViewModel()
        self.localUtilityManager = localUtilityManager
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.dataSource = nil
        getUserDetail()
        checkUserDetail()
    }

    // MARK: - Setup view methods
    private func setupView() {
        view.backgroundColor = .appColor(.background)
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: Metric.navigationTitleSize),
            NSAttributedString.Key.foregroundColor: UIColor.appColor(.color4) ?? .red
        ]
        
        let backBarButtonItem = UIBarButtonItem(title: Literal.mypageText, style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor.appColor(.color4)
        backBarButtonItem.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: Metric.navigationBackButtonTitleSize)
        ], for: .normal)
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private func setupLayout() {
        view.addSubviews([titleLabel, tableView])
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide)
                .offset(Metric.titleOffset)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
                .inset(Metric.titleOffset)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.settingsOffset)
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Binding table view metohds
    private func bindTableView() {
        viewModel.nicknameObservable
            .observe(on: MainScheduler.instance)
            .map { return "안녕하세요,\n"+$0+"님!" }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.writtenDiaryObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] writtenDiary in
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                let price = Double(writtenDiary)
                let result = (numberFormatter.string(from: NSNumber(value:price)) ?? "0") + "개"
                
                _ = Observable<[MyPageCellModel]>.just([
                    .writtenDiary(title: "작성한 일기 수", subtitle: result),
                    .settings(title: "설정"),
                    .logout(title: "logout", color: .red),
                    .resign(title: "회원탈퇴", color: .red)
                ])
                    .bind(to: (self?.tableView.rx.items)!) { (tableView, row, element) in
                        switch element {
                        case .writtenDiary(let title, let subtitle):
                            guard let cell = tableView.dequeueReusableCell(withIdentifier: Literal.writtenDiaryCellIdentifier)
                                    as? SettingsActionSheetCell else { return UITableViewCell() }
                            cell.configure(left: title, right: subtitle)
                            return cell
                        case .settings(let title):
                            guard let cell = tableView.dequeueReusableCell(withIdentifier: Literal.settingsCellIdentifier)
                                    as? SettingsActionSheetCell else { return UITableViewCell() }
                            cell.configure(center: title)
                            return cell
                        case .logout(let title, let color):
                            guard let cell = tableView.dequeueReusableCell(withIdentifier: Literal.logoutCellIdentifier)
                                    as? SettingsActionSheetCell else { return UITableViewCell() }
                            cell.configure(center: title, color: color)
                            return cell
                        case .resign(let title, let color):
                            guard let cell = tableView.dequeueReusableCell(withIdentifier: Literal.resignCellIdentifier)
                                    as? SettingsActionSheetCell else { return UITableViewCell() }
                            cell.configure(center: title, color: color)
                            return cell
                        }
                    }
                    .disposed(by: self?.disposeBag ?? DisposeBag())
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                guard let action = MyPageCellActions(rawValue: indexPath.row) else { return }
                switch action {
                case .setting:
                    self?.settingButtonTapped()
                case .logout:
                    self?.logoutButtonTapped()
                case .resign:
                    self?.resignButtonTapped()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Getting data methods
    private func getUserDetail() {
        viewModel.getUserDetail()
    }
    
    // MARK: - Action methods
    private func settingButtonTapped() {
        mypageDelegate?.settingButtonTapped()
    }
    
    private func logoutButtonTapped() {
        makeCancelOKAlert(title: Literal.logoutTitle, message: Literal.logoutMessage) { [weak self] _ in
            let token = self?.localUtilityManager.getToken(key: Literal.userToken)
            if let token = token {
                self?.viewModel.logout(token: token)
            }
            self?.localUtilityManager.deleteToken(key: Literal.userToken)
            self?.mypageDelegate?.logoutButtonTapped()
        }
    }
    
    private func resignButtonTapped() {
        makeCancelOKAlert(title: Literal.resignTitle, message: Literal.resignMessage) { [weak self] _ in
            self?.performResign()
        }
    }
    
    private func performResign() {
        viewModel.resign()
        makeOKAlert(title: Literal.confirmResignTitle, message: Literal.confirmResignMessage) { [weak self] _ in
            // TODO: 로그아웃에 쓰이는 과정을 하나의 메서드로 빼기
            self?.localUtilityManager.deleteToken(key: Literal.userToken)
            self?.mypageDelegate?.logoutButtonTapped()
        }
        
    private func checkUserDetail() {
        viewModel.failureObservable
            .subscribe(onNext: { [weak self] _ in
                self?.makeOKAlert(title: Literal.checkTitle, message: Literal.checkMessage) { [weak self] _ in
                    self?.localUtilityManager.deleteToken(key: Literal.userToken)
                    self?.mypageDelegate?.logoutButtonTapped()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Preview methods
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MyPageViewController_Preview: PreviewProvider {
    static var previews: some View {
        MyPageViewController().showPreview(.iPhone14Pro)
    }
}
#endif
