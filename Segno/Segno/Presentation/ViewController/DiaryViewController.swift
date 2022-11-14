//
//  DiaryViewController.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit

final class DiaryViewController: UIViewController {
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search Bar Test!"
        bar.setImage(UIImage(named: "search_back"), for: .search, state: .normal)
        bar.setImage(UIImage(named: "search_cancel"), for: .clear, state: .normal)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}
