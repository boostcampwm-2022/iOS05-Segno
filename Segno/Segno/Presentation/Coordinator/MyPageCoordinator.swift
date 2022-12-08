//
//  MyPageCoordinator.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit

final class MyPageCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MyPageViewController()
        vc.mypageDelegate = self
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension MyPageCoordinator: MyPageViewDelegate {
    func settingButtonTapped() {
        let vc = SettingsViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
