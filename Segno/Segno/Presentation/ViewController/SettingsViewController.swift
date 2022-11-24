//
//  SettingsViewController.swift
//  Segno
//
//  Created by 이예준 on 2022/11/24.
//

import UIKit

final class SettingsViewController: UIViewController {
    lazy var testLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings View Controller!"
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
    }

    private func setupView() {
        view.backgroundColor = .appColor(.background)
    }
    
    private func setupLayout() {
        view.addSubview(testLabel)
        
        testLabel.snp.makeConstraints {
            $0.centerX.centerY.equalTo(view)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct SettingsViewController_Preview: PreviewProvider {
    static var previews: some View {
        SettingsViewController().showPreview(.iPhone14Pro)
    }
}
#endif
