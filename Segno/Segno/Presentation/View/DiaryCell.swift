//
//  DiaryCell.swift
//  Segno
//
//  Created by 이예준 on 2022/11/15.
//

import UIKit

final class DiaryCell: UICollectionViewCell {
    // MARK: - Namespaces
    private enum Metric {
        static let labelFontSize: CGFloat = 20
        static let cornerRadius: CGFloat = 20
    }
    
    private enum Literal {
        static let thumbnaliImageName = UIImage(systemName: "photo.on.rectangle")
    }
    
    // MARK: - Views
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = .appFont(.shiningStar, size: Metric.labelFontSize)
        label.textAlignment = .center
        label.textColor = .appColor(.label)
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View setup methods
    private func setupView() {
        contentView.backgroundColor = .appColor(.color2)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = Metric.cornerRadius
        
        thumbnailImageView.image = Literal.thumbnaliImageName
        thumbnailImageView.tintColor = .appColor(.color4)
    }
    
    private func setupLayout() {
        [thumbnailImageView, titleLabel].forEach {
            contentView.addSubview($0)
            
            $0.snp.makeConstraints { make in
                make.width.equalTo(contentView)
                make.centerX.equalTo(contentView.snp.centerX)
            }
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            // TODO: 추후에 사진 비율 맞춰서 height 조절해주기
            make.height.equalTo(contentView.frame.width * 0.85)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom)
        }
    }
    
    // MARK: - Configure cell method
    func configure(with model: DiaryListItem) {
        titleLabel.text = model.title
        thumbnailImageView.setImage(imagePath: model.thumbnailPath)
    }
}
