//
//  LocationContentView.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/23.
//

import CoreLocation
import UIKit

import RxCocoa
import SnapKit

protocol LocationContentViewDelegate: AnyObject {
    func mapButtonTapped(location: Location)
}

final class LocationContentView: UIView {
    private enum Metric {
        static let fontSize: CGFloat = 16
        static let spacing: CGFloat = 10
        static let mapButtonSize: CGFloat = 30
    }
    
    private var location: CLLocation?
    weak var delegate: LocationContentViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.surround, size: Metric.fontSize)
        label.text = "위치"
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.surroundAir, size: Metric.fontSize)
        return label
    }()
    
    private lazy var mapButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "map.fill"), for: .normal)
        button.tintColor = .appColor(.black)
        button.rx.tap
            .bind { [weak self] in
                // TODO: CLLocation 변수 location을 Location으로 변환하는 로직 필요. 지금은 임시 데이터 부여
                let customLocation = Location(latitude: "37.248128", longitude: "127.076597")
                self?.delegate?.mapButtonTapped(location: customLocation)
            }
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
            $0.leading.equalTo(titleLabel.snp.trailing).offset(Metric.spacing)
        }
        
        mapButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Metric.mapButtonSize)
            $0.trailing.equalToSuperview().inset(Metric.spacing)
        }
    }
    
    func setLocation(location: CLLocation) {
        // TODO: titleLabel에 표시하기 위해 CLLocation을 주소 String으로 변환하는 로직 필요
        
        self.location = location
    }
}

