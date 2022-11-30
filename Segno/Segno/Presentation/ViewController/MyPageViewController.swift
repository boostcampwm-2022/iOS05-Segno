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

enum CellActions: Int {
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
}

final class MyPageViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    weak var delegate: MyPageViewDelegate?
    
    private enum Metric {
        static let titleText: String = "안녕하세요,\nboostcamp님!"
        
        static let settingsOffset: CGFloat = 100
        static let titleFontSize: CGFloat = 32
        static let titleOffset: CGFloat = 30
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
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        bindTableView()
    }

    private func setupView() {
        view.backgroundColor = .appColor(.background)
    }
    
    private func setupLayout() {
        [titleLabel, tableView].forEach {
            view.addSubview($0)

            $0.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.centerX.equalTo(view.snp.centerX)
            }
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(Metric.titleOffset)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.settingsOffset)
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindTableView() {
        let dataSource = Observable<[MyPageCellModel]>.just([
            .writtenDiary(title: "작성한 일기 수", subtitle: "123,456,789개"), // TODO: subtitle 불러오기
            .settings(title: "설정"),
            .logout(title: "logout", color: .red)
        ])
        
        dataSource
            .bind(to: tableView.rx.items) { (tableView, row, element) in
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
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                guard let action = CellActions(rawValue: indexPath.row) else { return }
                switch action {
                case .setting:
                    self?.settingButtonTapped()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func settingButtonTapped() {
        delegate?.settingButtonTapped()
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
