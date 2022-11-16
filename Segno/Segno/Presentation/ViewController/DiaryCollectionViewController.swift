//
//  DiaryViewController.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class DiaryCollectionViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, DiaryListItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DiaryListItem>
    
    enum Section: CaseIterable {
        case main
    }
    
    private enum Metric {
        static let inset: CGFloat = 20
    }
    
    let disposeBag = DisposeBag()
    private let viewModel: DiaryCollectionViewModel
    private var dataSource: DataSource?
    private var diaryCells: [DiaryListItem] = []
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search Bar Test!"
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
        diaryCollectionView.delegate = self
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
}

extension DiaryCollectionViewController: UICollectionViewDelegate {
    
}
