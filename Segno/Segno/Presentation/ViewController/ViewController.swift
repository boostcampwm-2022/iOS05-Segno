//
//  ViewController.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/09.
//

import UIKit

final class ViewController: UIViewController {
    let testLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World!"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(testLabel)
        
        NSLayoutConstraint.activate([
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

