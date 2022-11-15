//
//  DiaryViewController.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit
import SnapKit

final class DiaryCollectionViewController: UIViewController {
    // TODO: 추후에 viewModel도 가져와서 연결하기
    private let layout: UICollectionViewLayout
    
    private enum Metric {
        static let spacingBetweenButtons: CGFloat = 20
        static let inset: CGFloat = 20
     
        static let titleHeight: CGFloat = 100
        static let titleOffset: CGFloat = 200
        static let subTitleHeight: CGFloat = 50
        static let buttonHeight: CGFloat = 50
        static let buttonRadius: CGFloat = 20
    }
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search Bar Test!"
        bar.setImage(UIImage(named: "search_back"), for: .search, state: .normal)
        bar.setImage(UIImage(named: "search_cancel"), for: .clear, state: .normal)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    lazy var diaryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .appColor(.color1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(layout: UICollectionViewLayout) {
        self.layout = layout
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        view.backgroundColor = .appColor(.background)
    }

    private func setupLayout() {
        [searchBar, diaryCollectionView].forEach {
            view.addSubview($0)
            
            $0.snp.makeConstraints { make in
                make.width.equalToSuperview().inset(Metric.inset)
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
}
