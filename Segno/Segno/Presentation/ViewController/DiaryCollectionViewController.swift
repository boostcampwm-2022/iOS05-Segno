//
//  DiaryViewController.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

protocol DiaryCollectionViewDelegate: AnyObject {
    func diaryCellSelected(id: String)
}

final class DiaryCollectionViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, DiaryListItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DiaryListItem>
    
    enum Section: CaseIterable {
        case main
    }
    
    private enum Metric {
        static let buttonFontSize: CGFloat = 80
        static let buttonLabelOffset: CGFloat = 7
        static let buttonOffset: CGFloat = -20
        static let buttonRadius: CGFloat = 40
        static let buttonText: String = "+"
        static let buttonWidthAndHeight: CGFloat = 80
        static let inset: CGFloat = 20
        static let navigationTitleSize: CGFloat = 20
    }
    
    let disposeBag = DisposeBag()
    private let viewModel: DiaryCollectionViewModel
    private var dataSource: DataSource?
    private var diaryCells: [DiaryListItem] = []
    weak var delegate: DiaryCollectionViewDelegate?
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search Bar Test!"
        bar.searchTextField.font = .appFont(.shiningStar, size: 20)
        bar.setImage(UIImage(named: "search_back"), for: .search, state: .normal)
        bar.setImage(UIImage(named: "search_cancel"), for: .clear, state: .normal)
        return bar
    }()
    
    lazy var diaryCollectionView: UICollectionView = {
        let layout = makeCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .appColor(.color1)
        return collectionView
    }()
    
    lazy var appendButton = UIButton()
    
    lazy var appendButtonLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.surroundAir, size: Metric.buttonFontSize)
        label.text = Metric.buttonText
        label.textColor = .appColor(.white)
        return label
    }()
    
    init() {
        self.viewModel = DiaryCollectionViewModel()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        
        dataSource = makeDataSource()
        bindDataSource()
        getDatasource()
    }
    
    private func setupView() {
        view.backgroundColor = .appColor(.background)
        
        title = "일기 리스트"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.appFont(.surround, size: Metric.navigationTitleSize),
            NSAttributedString.Key.foregroundColor: UIColor.appColor(.color4) ?? .red]
        
        diaryCollectionView.delegate = self
        
        appendButton.layer.cornerRadius = Metric.buttonRadius
        appendButton.layer.masksToBounds = true
        
        appendButton.setBackgroundColor(.appColor(.color4) ?? .red, for: .normal)
    }

    private func setupLayout() {
        [searchBar, diaryCollectionView].forEach {
            view.addSubview($0)

            $0.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.centerX.equalTo(view.snp.centerX)
            }
        }

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
        }

        diaryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        [appendButton, appendButtonLabel].forEach {
            view.addSubview($0)
        }
        
        appendButton.snp.makeConstraints { make in
            make.width.equalTo(Metric.buttonWidthAndHeight)
            make.height.equalTo(Metric.buttonWidthAndHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(Metric.buttonOffset)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(Metric.buttonOffset)
        }
        
        appendButtonLabel.snp.makeConstraints { make in
            make.centerX.equalTo(appendButton)
            make.centerY.equalTo(appendButton).offset(Metric.buttonLabelOffset)
        }
    }
    
    private func makeDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration<DiaryCell, DiaryListItem> { (cell, _, item) in
            cell.configure(with: item)
        }
        
        let dataSource = DataSource(collectionView: diaryCollectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier
            )
        }
        
        return dataSource
    }
    
    private func bindDataSource() {
        viewModel.diaryListItems
            .subscribe(onNext: { [weak self] datas in
                self?.updateSnapshot(with: datas)
            })
            .disposed(by: disposeBag)
    }
    
    private func getDatasource() {
        viewModel.getDiaryList()
    }
}

extension DiaryCollectionViewController {
    func makeCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let cellWidth: CGFloat = UIScreen.main.bounds.width / 2 - 1
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        return layout
    }
    
    func updateSnapshot(with models: [DiaryListItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(models)
        
        dataSource?.apply(snapshot)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = dataSource?.itemIdentifier(for: indexPath)?.id else { return }
        
        delegate?.diaryCellSelected(id: id)
    }
}

extension DiaryCollectionViewController: UICollectionViewDelegate {
    
}
