//
//  MusicContentView.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/22.
//

import UIKit

import Kingfisher
import SnapKit

final class MusicContentView: UIView {
    private enum Metric {
        static let fontSize: CGFloat = 16
        static let spacing: CGFloat = 10
        static let albumArtImageViewSize: CGFloat = 30
        static let albumArtCornerRadius: CGFloat = 5
        static let playButtonSize: CGFloat = 30
    }
    
    private lazy var albumArtImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemMint
        imageView.layer.cornerRadius = Metric.albumArtCornerRadius
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.surround, size: Metric.fontSize)
        return label
    }()
    
    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.surroundAir, size: Metric.fontSize)
        return label
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .appColor(.black)
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
        [albumArtImageView, titleLabel, artistLabel, playButton].forEach {
            addSubview($0)
        }
        
        albumArtImageView.snp.makeConstraints {
            $0.width.height.equalTo(Metric.albumArtImageViewSize)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(Metric.spacing)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(albumArtImageView.snp.trailing).offset(Metric.spacing)
        }
        
        artistLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(Metric.spacing)
        }
        
        playButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Metric.playButtonSize)
            $0.trailing.equalToSuperview().inset(Metric.spacing)
        }
    }
    
    func setMusic(info: MusicInfo) {
        titleLabel.text = info.title
        artistLabel.text = info.artist
        albumArtImageView.kf.setImage(with: info.imageURL)
    }
}

