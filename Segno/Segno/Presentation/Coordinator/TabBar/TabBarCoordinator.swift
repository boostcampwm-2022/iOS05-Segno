//
//  TabBarCoordinator.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var childCoordinators: [Coordinator] = []
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let pages: [TabBarPageCase] = TabBarPageCase.allCases
        let controllers: [UINavigationController] = pages.map {
            self.createTabNavigationController(page: $0)
        }
        self.configureTabBarController(with: controllers)
    }
}

private extension TabBarCoordinator {
    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        self.tabBarController.selectedIndex = TabBarPageCase.diary.pageOrderNumber
        self.navigationController.pushViewController(tabBarController, animated: true)
    }
    
    func createTabNavigationController(page: TabBarPageCase) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.tabBarItem = self.configureTabBarItem(page: page)
        connectTabCoordinator(page: page, to: tabNavigationController)
        return tabNavigationController
    }
    
    func configureTabBarItem(page: TabBarPageCase) -> UITabBarItem {
        return UITabBarItem(
            title: page.pageTitle,
            image: UIImage(systemName: page.tabIconName),
            tag: page.pageOrderNumber
        )
    }
    
    func connectTabCoordinator(page: TabBarPageCase, to tabNavigationController: UINavigationController) {
        switch page {
        case .diary:
            connectDiaryFlow(to: tabNavigationController)
        case .mypage:
            connectMyPageFlow(to: tabNavigationController)
        }
    }
    
    func connectDiaryFlow(to tabNavigationController: UINavigationController) {
        let diaryCoordinator = DiaryCoordinator(tabNavigationController)
        diaryCoordinator.start()
        childCoordinators.append(diaryCoordinator)
    }
    
    func connectMyPageFlow(to tabNavigationController: UINavigationController) {
        let myPageCoordinator = MyPageCoordinator(tabNavigationController)
        myPageCoordinator.start()
        childCoordinators.append(myPageCoordinator)
    }
}
