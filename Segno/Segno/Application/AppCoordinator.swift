//
//  AppCoordinator.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit

final class AppCoordinator: Coordinator {
    let localUtilityRepository = LocalUtilityRepositoryImpl()
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        let token = localUtilityRepository.getToken()
        if token.isEmpty {
            startLoginCoordinator()
        } else {
            startTabBarCoordinator()
        }
    }
    
    func startLoginCoordinator() {
        let loginCoordinator = LoginCoordinator(navigationController)
        loginCoordinator.delegate = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
    
    func startTabBarCoordinator() {
        let tabBarCoordinator = TabBarCoordinator(navigationController)
        tabBarCoordinator.delegate = self
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

extension AppCoordinator: TabBarCoordinatorDelegate {
    func logoutButtonTapped() {
        navigationController.popViewController(animated: true)
        
        startLoginCoordinator()
    }
}
