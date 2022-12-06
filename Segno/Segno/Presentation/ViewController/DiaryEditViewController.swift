//
//  DiaryEditViewController.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/23.
//

import UIKit

import MarqueeLabel
import RxCocoa
import RxSwift
import SnapKit

final class DiaryEditViewController: UIViewController {
    private enum Metric {
        // 스택 뷰 관련 설정
        static let standardSpacing: CGFloat = 8
        static let doubleSpacing: CGFloat = 16
        static let stackViewInset: CGFloat = 16
        
        // 스택 뷰 안에 들어가는 컨텐츠 설정
        static let majorContentHeight: CGFloat = 400
        static let minorContentHeight: CGFloat = 60
        static let halfMinorContentHeight: CGFloat = 30
        static let standardCornerRadius: CGFloat = 8
        static let mediumFontSize: CGFloat = 24
        static let smallFontSize: CGFloat = 16
        static let titlePlaceholder = "제목을 입력하세요."
        static let musicPlaceholder = "지금 이 음악은 뭘까요?"
        static let locationPlaceholder = "여기는 어디인가요?"
        static let imageViewStockImage = UIImage(systemName: "photo")
        
        // 스택 뷰 안에 들어가는 버튼 설정
        static let musicButtonImage = UIImage(systemName: "music.note")
        static let locationButtonImage = UIImage(systemName: "location.fill")
        static let saveButtonTitle = "저장"
        static let buttonCornerRadius = CGFloat(minorContentHeight / 2)
        static let tagButtonCornerRadius = CGFloat(halfMinorContentHeight / 2)
    }
    
    let viewModel: DiaryEditViewModel
    private let shazamSession = ShazamSession() // 임시로 연동 - 추후 분리 예정
    private var disposeBag = DisposeBag()
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = Metric.standardSpacing
        return stackView
    }()
    
    // TODO: 이미지 뷰를 버튼처럼 활용할 수 있도록 액션 연결
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .appFont(.surroundAir, size: Metric.mediumFontSize)
        textField.placeholder = Metric.titlePlaceholder
        return textField
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .appColor(.color4)
        imageView.contentMode = .scaleAspectFit
        imageView.image = Metric.imageViewStockImage
        imageView.layer.cornerRadius = Metric.standardCornerRadius
        return imageView
    }()
    
    private lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .appColor(.color2)
        textView.font = .appFont(.shiningStar, size: Metric.mediumFontSize)
        textView.layer.borderColor = UIColor.appColor(.color4)?.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = Metric.standardCornerRadius
        return textView
    }()
    
    private lazy var tagScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = Metric.standardSpacing
        return stackView
    }()
    
    private lazy var addTagButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black // 테스트용 색상..?
        button.layer.cornerRadius = Metric.tagButtonCornerRadius
        button.setTitle("+", for: .normal)
        return button
    }()
    
    private lazy var musicStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .appColor(.color1)
        stackView.distribution = .equalSpacing
        stackView.layer.cornerRadius = Metric.standardCornerRadius
        stackView.spacing = Metric.doubleSpacing
        return stackView
    }()
    
    private lazy var addMusicButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appColor(.color3)
        button.layer.cornerRadius = Metric.buttonCornerRadius
        button.setImage(Metric.musicButtonImage, for: .normal)
        return button
    }()
    
    private lazy var musicInfoLabel: MarqueeLabel = {
        let label = MarqueeLabel(frame: .zero, rate: 32, fadeLength: 32.0)
        label.font = .appFont(.surroundAir, size: Metric.smallFontSize)
        label.text = Metric.musicPlaceholder
        label.trailingBuffer = 16.0
        return label
    }()
    
    private lazy var locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .appColor(.color1)
        stackView.distribution = .equalSpacing
        stackView.layer.cornerRadius = Metric.standardCornerRadius
        stackView.spacing = Metric.doubleSpacing
        return stackView
    }()
    
    private lazy var addlocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appColor(.color3) // 테스트용 색상..?
        button.layer.cornerRadius = Metric.buttonCornerRadius
        button.setImage(Metric.locationButtonImage, for: .normal)
        return button
    }()
    
    private lazy var locationInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.surroundAir, size: Metric.smallFontSize)
        label.text = Metric.locationPlaceholder
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appColor(.color4)
        button.layer.cornerRadius = Metric.standardCornerRadius
        button.setTitle(Metric.saveButtonTitle, for: .normal)
        button.titleLabel?.font = .appFont(.surroundAir, size: Metric.smallFontSize)
        return button
    }()
    
    private lazy var tapGesture = UITapGestureRecognizer()
    
    init(viewModel: DiaryEditViewModel = DiaryEditViewModel()) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindImageView()
        
        // 샤잠킷 연동 메서드입니다. 향후 조정 예정입니다.
        bindLabel()
        bindButtonAction()
        bindSearchResult()
    }
    
    private func setupView() {
        view.backgroundColor = .appColor(.white)
        
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainScrollView.addSubview(contentsStackView)
        contentsStackView.snp.makeConstraints {
            $0.edges.equalTo(mainScrollView)
                .inset(Metric.stackViewInset)
            $0.width.equalTo(mainScrollView)
                .inset(Metric.stackViewInset)
        }
        
        setupContentsStackView()
    }
    
    private func setupContentsStackView() {
        contentsStackView.addArrangedSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.height.equalTo(Metric.halfMinorContentHeight)
        }
        
        contentsStackView.addArrangedSubview(photoImageView)
        photoImageView.addGestureRecognizer(tapGesture)
        photoImageView.snp.makeConstraints {
            $0.height.equalTo(Metric.majorContentHeight)
        }
        
        contentsStackView.addArrangedSubview(bodyTextView)
        bodyTextView.snp.makeConstraints {
            $0.height.equalTo(Metric.majorContentHeight)
        }
        
        contentsStackView.addArrangedSubview(tagScrollView)
        tagScrollView.snp.makeConstraints {
            $0.height.equalTo(Metric.halfMinorContentHeight)
        }
        setupTagScrollView()
        
        contentsStackView.addArrangedSubview(musicStackView)
        musicStackView.snp.makeConstraints {
            $0.height.equalTo(Metric.minorContentHeight)
        }
        setupMusicStackView()
        
        contentsStackView.addArrangedSubview(locationStackView)
        locationStackView.snp.makeConstraints {
            $0.height.equalTo(Metric.minorContentHeight)
        }
        setupLocationStackView()
        
        contentsStackView.addArrangedSubview(saveButton)
    }
    
    private func setupTagScrollView() {
        tagScrollView.addSubview(tagStackView)
        tagStackView.snp.makeConstraints {
            $0.edges.equalTo(tagScrollView)
            $0.height.equalTo(tagScrollView)
        }
        
        tagStackView.addArrangedSubview(addTagButton)
    }
    
    private func setupMusicStackView() {
        musicStackView.addArrangedSubview(addMusicButton)
        addMusicButton.snp.makeConstraints {
            $0.width.equalTo(Metric.minorContentHeight)
        }
        musicStackView.addArrangedSubview(musicInfoLabel)
    }
    
    private func setupLocationStackView() {
        locationStackView.addArrangedSubview(addlocationButton)
        addlocationButton.snp.makeConstraints {
            $0.width.equalTo(Metric.minorContentHeight)
        }
        locationStackView.addArrangedSubview(locationInfoLabel)
    }
    
    private func bindImageView() {
        tapGesture.rx.event
            .bind(onNext: { recognizer in
                print("gestures: \(recognizer.numberOfTouches)")
            })
            .disposed(by: disposeBag)
    }
}

// 샤잠킷 로직 부분 - 추후 뜯어서 옮길 계획입니다.
extension DiaryEditViewController {
    private func bindLabel() {
        shazamSession.isSearching
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { searchState in
                switch searchState {
                case true:
                    self.musicInfoLabel.text = "검색 중입니다..."
                case false:
                    self.musicInfoLabel.text = "지금 이 음악은 뭘까요?"
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindButtonAction() {
        addMusicButton.rx.tap
            .withUnretained(self)
            .bind { _ in
                self.searchTapped()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindSearchResult() {
        shazamSession.result
            .subscribe(onNext: { result in
                switch result {
                case .success(let song):
                    let title = song.title
                    let artist = song.artist
                    
                    let musicInfo = MusicInfo(shazamSong: song) // 뷰모델에서 이 작업을 할 때, 향후 사용될 엔티티
                    debugPrint(musicInfo)
                    
                    DispatchQueue.main.async {
                        self.musicInfoLabel.text = "\(artist) - \(title)"
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.musicInfoLabel.text = "음악을 찾지 못했어요."
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func searchTapped() {
        shazamSession.toggleSearch() // 지워질 예정
        viewModel.startSearchingMusic()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { info in
                self.musicInfoLabel.text = "\(info.artist) - \(info.title)"
            }, onFailure: { _ in
                self.musicInfoLabel.text = "음악을 찾지 못했어요."
            })
            .disposed(by: disposeBag)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct DiaryEditViewController_Preview: PreviewProvider {
    static var previews: some View {
        DiaryEditViewController().showPreview(.iPhone14Pro)
    }
}
#endif
