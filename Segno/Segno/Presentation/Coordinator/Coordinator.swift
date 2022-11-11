//
//  Coordinator.swift
//  Segno
//
//  Created by 이예준 on 2022/11/10.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    init(_ navigationController: UINavigationController)
    
    func start()
}
