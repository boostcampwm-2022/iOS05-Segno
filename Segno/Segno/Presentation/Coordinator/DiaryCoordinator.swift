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
        // TODO: 추후에 올바른 layout 보내주기
        let vc = DiaryViewController(layout: UICollectionViewLayout())
        self.navigationController.pushViewController(vc, animated: true)
    }
}
