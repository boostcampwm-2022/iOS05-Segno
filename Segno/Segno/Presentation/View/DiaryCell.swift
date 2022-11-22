//
//  DiaryCell.swift
//  Segno
//
//  Created by 이예준 on 2022/11/15.
//

import UIKit

final class DiaryCell: UICollectionViewCell {
    private enum Metric {
        static let labelFontSize: CGFloat = 20
    }
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 0.5 // MARK: 추후 삭제
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.shiningStar, size: Metric.labelFontSize)
        label.textAlignment = .center
        label.layer.borderWidth = 0.5 // MARK: 추후 삭제
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = .appColor(.color3)
        
        thumbnailImageView.image = UIImage(systemName: "popcorn.fill")
        titleLabel.text = "Title"
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
    
    func configure(with model: DiaryListItem) {
        // TODO: 추후에 서버에서 path 받아오면 실행해주기
//        if let path = model.imagePath {
//            posterImageView.load(from: path)
//        }
        titleLabel.text = model.title
    }
}
