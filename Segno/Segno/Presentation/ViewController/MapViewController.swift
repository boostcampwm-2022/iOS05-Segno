//
//  MapViewController.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/24.
//

import MapKit
import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class MapViewController: UIViewController {
    // MARK: - Namespaces
    private enum Metric {
        static let topSpace: CGFloat = 30
        static let bottomSpace: CGFloat = 80
        static let edgeSpace: CGFloat = 20
        static let mapViewHeight: CGFloat = 500
        static let titleSize: CGFloat = 40
        static let buttonSize: CGFloat = 20
        static let addressSize: CGFloat = 16
    }
    
    // MARK: - Properties
    private let viewModel: MapViewModel
    private let location: Location
    private var disposeBag = DisposeBag()
    
    // MARK: - Views
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: Metric.titleSize, weight: .bold)
        titleLabel.text = "위치"
        return titleLabel
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "x.circle"), for: .normal)
        closeButton.tintColor = .appColor(.color4)
        
        var config = UIButton.Configuration.plain()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Metric.buttonSize)
        config.preferredSymbolConfigurationForImage = imageConfig
        closeButton.configuration = config
        let action = UIAction { _ in
            self.dismiss(animated: true)
        }
        closeButton.addAction(action, for: .touchUpInside)
        return closeButton
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    private lazy var addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.font = .systemFont(ofSize: Metric.addressSize)
        return addressLabel
    }()
    
    // MARK: - Initializers
    init(viewModel: MapViewModel, location: Location) {
        self.viewModel = viewModel
        self.location = location

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupMapView()
        bindAddressItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAddress()
    }
    
    // MARK: - Setup view methods
    private func setupMapView() {
        let latitude = location.latitude
        let longitude = location.longitude
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: locationCoordinate, span: span)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
    }
    
    private func setupLayout() {
        view.addSubviews([titleLabel, closeButton, mapView, addressLabel])
        view.backgroundColor = .appColor(.background)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Metric.topSpace)
            $0.leading.equalToSuperview().inset(Metric.edgeSpace)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(Metric.edgeSpace)
            $0.width.height.equalTo(Metric.buttonSize)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Metric.edgeSpace)
            $0.leading.trailing.equalToSuperview().inset(Metric.edgeSpace)
            $0.bottom.equalTo(addressLabel.snp.top).offset(-Metric.edgeSpace)
        }
        
        addressLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(Metric.bottomSpace)
            $0.leading.equalToSuperview().inset(Metric.edgeSpace)
        }
    }
    
    // MARK: Bind view methods
    private func bindAddressItem() {
        viewModel.addressSubject
            .bind(to: addressLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Get data methods
    private func getAddress() {
        viewModel.getAddress(by: location)
    }
}

// MARK: - Preview methods
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MapKitViewController_Preview: PreviewProvider {
    static var previews: some View {
        MapViewController(
            viewModel: MapViewModel(),
            location: Location(latitude: 37.248128, longitude: 127.076597)
        )
            .showPreview(.iPhone14Pro)
    }
}
#endif
