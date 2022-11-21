//
//  AppCoordinator.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        // TODO: login이 안되어있으면 LoginCoordinator 실행
        startLoginCoordinator()
        // TODO: login이 되어있으면 TabBarCoordinator 실행
    }
    
    func startLoginCoordinator() {
        let loginCoordinator = LoginCoordinator(navigationController)
        loginCoordinator.delegate = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
    
    func startTabBarCoordinator() {
        let tabBarCoordinator = TabBarCoordinator(navigationController)
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
}

extension AppCoordinator: LoginCoordinatorDelegate {
    func loginDidSucceed(_ coordinator: LoginCoordinator) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
        
        startTabBarCoordinator()
    }
}
