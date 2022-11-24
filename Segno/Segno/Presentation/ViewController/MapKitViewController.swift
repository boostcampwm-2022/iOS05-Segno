//
//  MapKitViewController.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/24.
//

import MapKit
import UIKit

import SnapKit

class MapKitViewController: UIViewController {

    private enum Metric {
        static let space = 20
    }
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.backgroundColor = .yellow
        return mapView
    }()
    
    init(location: Location) {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemMint
        setupMapView(location: location)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    private func setupMapView(location: Location) {
        
    }
    
    private func setupLayout() {
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view).inset(20)
            $0.height.equalTo(500)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MapKitViewController_Preview: PreviewProvider {
    static var previews: some View {
        MapKitViewController(location: Location(latitude: "37.248128", longitude: "127.076597"))
            .showPreview(.iPhone14Pro)
    }
}
#endif
