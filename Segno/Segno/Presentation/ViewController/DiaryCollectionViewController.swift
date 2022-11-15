//
//  DiaryViewController.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit
import SnapKit

final class DiaryCollectionViewController: UIViewController {
    private enum Metric {
        static let inset: CGFloat = 20
    }
    
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
}
