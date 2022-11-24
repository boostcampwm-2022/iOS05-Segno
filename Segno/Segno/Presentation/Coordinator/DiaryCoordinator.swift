//
//  DiaryCoordinator.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit

final class DiaryCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = DiaryCollectionViewController()
        vc.delegate = self
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension DiaryCoordinator: DiaryCollectionViewDelegate {
    func diaryCellSelected(id: String) {
        // TODO: id 사용하여 DiaryDetailViewController에 전달하기
        // ex) let vc = DiaryDetailViewController(viewModel: DiaryDetailViewModel(itemIdentifier: id))
        let vc = DiaryDetailViewController(viewModel: DiaryDetailViewModel(itemIdentifier: id))
        navigationController.pushViewController(vc, animated: true)
    }
}
