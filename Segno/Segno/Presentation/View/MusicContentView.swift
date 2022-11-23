//
//  MusicContentView.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/22.
//

import UIKit

import SnapKit

final class MusicContentView: UIView {
    private let albumArtImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemMint
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
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
            $0.width.height.equalTo(30)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(albumArtImageView.snp.trailing).offset(10)
        }
        
        artistLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(10)
        }
        
        playButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    func setMusic(title: String, artist: String) {
        titleLabel.text = title
        artistLabel.text = artist
    }
}

