//
//  LoginCoordinator.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit

protocol LoginCoordinatorDelegate: AnyObject {
    func loginDidSucceed(_ coordinator: LoginCoordinator)
}

final class LoginCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: LoginCoordinatorDelegate?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = LoginViewController()
        vc.delegate = self
        self.navigationController.pushViewController(vc, animated: false)
    }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func loginDidSucceed() {
        delegate?.loginDidSucceed(self)
    }
}
