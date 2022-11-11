//
//  LoginCoordinator.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit

final class LoginCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = LoginViewController()
        self.navigationController.pushViewController(vc, animated: true)
    }
}
