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
        let vc = DiaryDetailViewController(viewModel: DiaryDetailViewModel(itemIdentifier: id))
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func diaryAppendButtonTapped() {
        let vc = DiaryEditViewController()
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension DiaryCoordinator: DiaryDetailViewDelegate {
    func mapButtonTapped(viewController: UIViewController, location: Location) {
        let mapKitViewController = MapViewController(viewModel: MapViewModel(), location: location)
        viewController.present(mapKitViewController, animated: true)
    }
    
    func editButtonTapped(diaryData: DiaryDetail?) {
        let diaryEditViewController = DiaryEditViewController(viewModel: DiaryEditViewModel(diaryData: diaryData))
        diaryEditViewController.delegate = self
        navigationController.pushViewController(diaryEditViewController, animated: true)
    }
    
    func escapeToCollectionView() {
        let targetVC = navigationController.viewControllers.first { $0 is DiaryCollectionViewController }
        if let targetVC = targetVC {
            navigationController.popToViewController(targetVC, animated: true)
        }
    }
}

extension DiaryCoordinator: DiaryEditViewDelegate {
    func diaryDidSaved() {
        let targetVC = navigationController.viewControllers.first { $0 is DiaryCollectionViewController }
        if let targetVC = targetVC {
            navigationController.popToViewController(targetVC, animated: true)
        }
    }
}
