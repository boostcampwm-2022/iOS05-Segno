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
    
    var toRow: Int {
        return self.rawValue
    }
}

enum MyPageCellModel {
    case writtenDiary(title: String, subtitle: String)
    case settings(title: String)
    case logout(title: String, color: UIColor)
}

protocol MyPageViewDelegate: AnyObject {
    func settingButtonTapped()
    func logoutButtonTapped()
}

final class MyPageViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: MyPageViewModel
    private let localUtilityRepository: LocalUtilityRepository
    weak var mypageDelegate: MyPageViewDelegate?
    
    private enum Metric {
        static let titleText: String = "안녕하세요,\nboostcamp님!"
        static let mypageText: String = "마이페이지"
        static let settingsOffset: CGFloat = 100
        static let titleFontSize: CGFloat = 32
        static let titleOffset: CGFloat = 30
        static let separatorInset: CGFloat = 15
        static let navigationTitleSize: CGFloat = 20
        static let navigationBackButtonTitleSize: CGFloat = 16
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.surround, size: Metric.titleFontSize)
        label.numberOfLines = 0
        label.text = Metric.titleText
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .appColor(.background)
        tableView.register(SettingsActionSheetCell.self, forCellReuseIdentifier: "writtenDiary")
        tableView.register(SettingsActionSheetCell.self, forCellReuseIdentifier: "settings")
        tableView.register(SettingsActionSheetCell.self, forCellReuseIdentifier: "logout")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: Metric.separatorInset, bottom: 0, right: Metric.separatorInset)
        return tableView
    }()
    
    init(viewModel: MyPageViewModel = MyPageViewModel(),
         localUtilityRepository: LocalUtilityRepository = LocalUtilityRepositoryImpl()) {
        self.viewModel = MyPageViewModel()
        self.localUtilityRepository = localUtilityRepository
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.dataSource = nil
        getUserDetail()
    }

    private func setupView() {
        view.backgroundColor = .appColor(.background)
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.appFont(.surround, size: Metric.navigationTitleSize),
            NSAttributedString.Key.foregroundColor: UIColor.appColor(.color4) ?? .red
        ]
        
        let backBarButtonItem = UIBarButtonItem(title: Metric.mypageText, style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor.appColor(.color4)
        backBarButtonItem.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.appFont(.surroundAir, size: Metric.navigationBackButtonTitleSize)], for: .normal)
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private func setupLayout() {
        view.addSubviews([titleLabel, tableView])
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(Metric.titleOffset)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.settingsOffset)
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
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
                    .logout(title: "logout", color: .red)
                ])
                    .bind(to: (self?.tableView.rx.items)!) { (tableView, row, element) in
                        switch element {
                        case .writtenDiary(let title, let subtitle):
                            guard let cell = tableView.dequeueReusableCell(withIdentifier: "writtenDiary") as? SettingsActionSheetCell else { return UITableViewCell() }
                            cell.configure(left: title, right: subtitle)
                            return cell
                        case .settings(let title):
                            guard let cell = tableView.dequeueReusableCell(withIdentifier: "settings") as? SettingsActionSheetCell else { return UITableViewCell() }
                            cell.configure(center: title)
                            return cell
                        case .logout(let title, let color):
                            guard let cell = tableView.dequeueReusableCell(withIdentifier: "logout") as? SettingsActionSheetCell else { return UITableViewCell() }
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
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func getUserDetail() {
        viewModel.getUserDetail()
    }
    
    private func settingButtonTapped() {
        mypageDelegate?.settingButtonTapped()
    }
    
    private func logoutButtonTapped() {
        _ = localUtilityRepository.deleteToken()
        
        mypageDelegate?.logoutButtonTapped()
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MyPageViewController_Preview: PreviewProvider {
    static var previews: some View {
        MyPageViewController().showPreview(.iPhone14Pro)
    }
}
#endif
