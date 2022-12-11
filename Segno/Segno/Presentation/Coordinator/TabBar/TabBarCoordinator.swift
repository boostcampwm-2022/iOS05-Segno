//
//  TabBarCoordinator.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit

protocol TabBarCoordinatorDelegate: AnyObject {
    func logoutButtonTapped()
}

final class TabBarCoordinator: Coordinator {
    private enum Metric {
        static let tabBarItemFontSize: CGFloat = 15
    }
    
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var childCoordinators: [Coordinator] = []
    weak var delegate: TabBarCoordinatorDelegate?
    
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
        self.navigationController.pushViewController(tabBarController, animated: false)
    }
    
    func createTabNavigationController(page: TabBarPageCase) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.tabBarItem = self.configureTabBarItem(page: page)
        tabNavigationController.tabBarItem.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.appFont(.shiningStar, size: Metric.tabBarItemFontSize)],
            for: .normal)
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
        myPageCoordinator.delegate = self
        myPageCoordinator.start()
        childCoordinators.append(myPageCoordinator)
    }
}

extension TabBarCoordinator: MyPageCoordinatorDelegate {
    func logoutButtonTapped() {
        delegate?.logoutButtonTapped()
    }
}
