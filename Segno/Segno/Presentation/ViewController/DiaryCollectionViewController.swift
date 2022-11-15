//
//  DiaryViewController.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit

final class DiaryCollectionViewController: UIViewController {
    // TODO: 추후에 viewModel도 가져와서 연결하기
    private let layout: UICollectionViewLayout
    
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
        // TODO: 추후에 .black 같은 Magic Number 삭제
        collectionView.backgroundColor = .black
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
    }

    private func setupView() {
        // TODO: 추후에 .white 같은 Magic Number 삭제
        view.backgroundColor = .white
        view.addSubview(searchBar)
        
        // TODO: 추후에 SnapKit 적용하여 레이아웃 맞추기
        NSLayoutConstraint.activate([
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(diaryCollectionView)
        
        NSLayoutConstraint.activate([
            diaryCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            diaryCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            diaryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
