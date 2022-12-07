//
//  UIViewController+.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/08.
//

import UIKit

extension UIViewController {
    func makeOKAlert(title: String, message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: completion)
    }
    
}
