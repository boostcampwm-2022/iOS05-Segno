//
//  UIViewController+.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/08.
//

import UIKit

extension UIViewController {
    // OK를 누르면 소멸하고 아무것도 하지 않는 얼럿입니다.
    func makeOKAlert(title: String, message: String, action: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: .cancel, handler: action)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    // 캔슬과 OK가 있는 얼럿입니다. OK에서 수행해 줄 액션을 action에 작성해주면 될 것으로 기대합니다.
    func makeCancelOKAlert(title: String, message: String, action: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: action)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}

enum DeviceType {
    case iPhone14Pro
    
    func name() -> String {
        switch self {
        case .iPhone14Pro:
            return "iPhone 14 Pro"
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func showPreview(_ deviceType: DeviceType = .iPhone14Pro) -> some View {
        Preview(viewController: self).previewDevice(PreviewDevice(rawValue: deviceType.name()))
    }
}
#endif
