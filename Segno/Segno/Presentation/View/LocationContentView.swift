//
//  LocationContentView.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/23.
//

import CoreLocation
import UIKit

import RxCocoa
import RxSwift
import SnapKit

protocol LocationContentViewDelegate: AnyObject {
    func mapButtonTapped(location: Location)
}

final class LocationContentView: UIView {
    private enum Metric {
        static let fontSize: CGFloat = 16
        static let spacing: CGFloat = 10
        static let mapButtonSize: CGFloat = 30
        static let mapButtonCornerRadius = mapButtonSize / 2
        static let titleText: String = "위치"
    }
    
    private var location: Location?
    private let disposeBag = DisposeBag()
    weak var delegate: LocationContentViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.surround, size: Metric.fontSize)
        label.text = Metric.titleText
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = .appFont(.surroundAir, size: Metric.fontSize)
        return label
    }()
    
    private lazy var mapButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appColor(.color4)
        button.layer.cornerRadius = Metric.mapButtonCornerRadius
        button.setImage(UIImage(systemName: "map.fill"), for: .normal)
        button.tintColor = .appColor(.white)
        button.rx.tap
            .bind { [weak self] in
                debugPrint("===>", self?.location)
                guard let location = self?.location else { return }
                self?.delegate?.mapButtonTapped(location: location)
            }
            .disposed(by: disposeBag)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [titleLabel, locationLabel, mapButton].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Metric.spacing)
        }
        
        locationLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing)
                .offset(Metric.spacing)
            $0.trailing.equalTo(mapButton.snp.leading)
                .offset(-Metric.spacing)
        }
        
        mapButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Metric.mapButtonSize)
            $0.trailing.equalToSuperview().inset(Metric.spacing)
        }
    }
    
    func setLocation(cllocation: CLLocation) {
        let latitude = cllocation.coordinate.latitude
        let longitude = cllocation.coordinate.longitude
        let location = Location(latitude: latitude, longitude: longitude)
        self.location = location
    }
}

