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
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func loginDidSucceed() {
        print("로그인 성공. 화면 전환")
    }
    
    func loginDidFail() {
        print("로그인 실패. 얼럿 팝업 반환")
    }
}
