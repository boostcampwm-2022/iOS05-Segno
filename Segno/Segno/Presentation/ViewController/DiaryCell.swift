//
//  DiaryCell.swift
//  Segno
//
//  Created by 이예준 on 2022/11/15.
//

import UIKit

final class DiaryCell: UICollectionViewCell {
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .appColor(.color3)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
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
            make.height.equalTo(contentView.frame.height)
        }
    }
}
