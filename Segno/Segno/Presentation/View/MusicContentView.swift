//
//  MusicContentView.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/22.
//

import UIKit

import MarqueeLabel
import RxSwift
import SnapKit

protocol MusicContentViewDelegate: AnyObject {
    func playButtonTapped()
}

final class MusicContentView: UIView {
    private enum Metric {
        static let fontSize: CGFloat = 16
        static let spacing: CGFloat = 10
        static let albumArtImageViewSize: CGFloat = 30
        static let albumArtCornerRadius: CGFloat = 5
        static let playButtonSize: CGFloat = 30
        static let playButtonCornerRadius = playButtonSize / 2
        static let playImage = UIImage(systemName: "play.fill")
        static let pauseImage = UIImage(systemName: "pause.fill")
    }
    
    private let disposeBag = DisposeBag()
    weak var delegate: MusicContentViewDelegate?
    
    private lazy var albumArtImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .appColor(.grey2)
        imageView.layer.cornerRadius = Metric.albumArtCornerRadius
        return imageView
    }()
    
    private lazy var musicInfoLabel: MarqueeLabel = {
        let label = MarqueeLabel(frame: .zero, rate: 32, fadeLength: 32.0)
//        label.font = .appFont(.surround, size: Metric.fontSize)
        label.font = .systemFont(ofSize: Metric.fontSize)
        return label
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appColor(.color4)
        button.layer.cornerRadius = Metric.playButtonCornerRadius
        button.setImage(Metric.playImage, for: .normal)
        button.tintColor = .appColor(.label)
        button.rx.tap
            .bind { [weak self] in
                self?.delegate?.playButtonTapped()
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
        [albumArtImageView, musicInfoLabel, playButton].forEach {
            addSubview($0)
        }
        
        albumArtImageView.snp.makeConstraints {
            $0.width.height.equalTo(Metric.albumArtImageViewSize)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(Metric.spacing)
        }
        
        musicInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(playButton.snp.leading)
                .offset(-Metric.spacing)
            $0.leading.equalTo(albumArtImageView.snp.trailing)
                .offset(Metric.spacing)
        }
        
        playButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Metric.playButtonSize)
            $0.trailing.equalToSuperview().inset(Metric.spacing)
        }
    }
    
    func setMusic(info: MusicInfo) {
        musicInfoLabel.text = "\(info.artist) - \(info.title)  "
        guard let imageURL = info.imageURL else { return }
        albumArtImageView.setImage(urlString: imageURL)
    }
    
    func activatePlayButton(isReady status: Bool) {
        playButton.isEnabled = status
    }
    
    func changeButtonIcon(isPlaying status: Bool) {
        switch status {
        case true:
            playButton.setImage(Metric.pauseImage, for: .normal)
        case false:
            playButton.setImage(Metric.playImage, for: .normal)
        }
    }
}

