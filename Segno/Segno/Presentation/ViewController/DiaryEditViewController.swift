//
//  DiaryEditViewController.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/23.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class DiaryEditViewController: UIViewController {
    private enum Metric {
        static let standardSpacing: CGFloat = 8
        static let doubleSpacing: CGFloat = 16
        
        static let majorContentHeight: CGFloat = 400
        static let minorContentHeight: CGFloat = 60
        static let halfMinorContentHeight: CGFloat = 30
        
        static let stackViewInset: CGFloat = 16
        static let standardCornerRadius: CGFloat = 8
        static let mediumFontSize: CGFloat = 24
        static let smallFontSize: CGFloat = 16
        
        static let titlePlaceholder = "제목을 입력하세요."
        static let musicPlaceholder = "지금 이 음악은 뭘까요?"
        static let locationPlaceholder = "여기는 어디인가요?"
        
        static let imageViewStockImage = UIImage(systemName: "photo")
        static let musicButtonImage = UIImage(systemName: "music.note")
        static let locationButtonImage = UIImage(systemName: "location.fill")
        
        static let buttonCornerRadius = CGFloat(minorContentHeight / 2)
        static let tagButtonCornerRadius = CGFloat(halfMinorContentHeight / 2)
    }
    
//    let viewModel: DiaryEditViewModel
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemPink // 테스트용 색상
        return scrollView
    }()
    
    private lazy var contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .systemGreen // 테스트용 색상
        stackView.distribution = .equalSpacing
        stackView.spacing = Metric.standardSpacing
        return stackView
    }()
    
    // TODO: 이미지 뷰를 버튼처럼 활용할 수 있도록 액션 연결
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray // 테스트용 색상
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
        textView.backgroundColor = .systemCyan // 테스트용 색상
        textView.font = .appFont(.shiningStar, size: Metric.mediumFontSize)
        textView.layer.cornerRadius = Metric.standardCornerRadius
        return textView
    }()
    
    private lazy var tagScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemTeal // 테스트용 색상
        return scrollView
    }()
    
    private lazy var tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.backgroundColor = .systemBrown // 테스트용 색상
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
        stackView.backgroundColor = .systemIndigo // 테스트용 색상
        stackView.distribution = .equalSpacing
        stackView.spacing = Metric.doubleSpacing
        return stackView
    }()
    
    private lazy var addMusicButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black // 테스트용 색상..?
        button.layer.cornerRadius = Metric.buttonCornerRadius
        button.setImage(Metric.musicButtonImage, for: .normal)
        return button
    }()
    
    private lazy var musicInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.surroundAir, size: Metric.smallFontSize)
        label.text = Metric.musicPlaceholder
        return label
    }()
    
    private lazy var locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .systemOrange
        stackView.distribution = .equalSpacing
        stackView.spacing = Metric.doubleSpacing
        return stackView
    }()
    
    private lazy var addlocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black // 테스트용 색상..?
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
    
//    private lazy var cancelButton: UIBarButtonItem = {
//        let barButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
//        return barButton
//    }()
//
//    private lazy var saveButton: UIBarButtonItem = {
//        let barButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
//        return barButton
//    }()
    
//    // 뷰 모델이 작성되었을 경우, 위의 뷰 모델 프로퍼티 주석 해제와 함께 사용하면 됩니다.
//    init(viewModel: DiaryEditViewModel
//         = DiaryEditViewModel()) {
//        self.viewModel = viewModel
//
//        super.init(nibName: nil, bundle: nil)
//    }
    
    // 뷰 모델이 작성되기 전 임시로 사용하는 이니셜라이저입니다.
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupNavigationBar()
        setupView()
    }
    
    // TODO: 내비게이션 바 관련 요소는 코디네이터 작업 후 활성화할 계획입니다.
//    private func setupNavigationBar() {
//        navigationController?.title = "일기 작성"
//        navigationItem.leftBarButtonItem = cancelButton
//        navigationItem.rightBarButtonItem = saveButton
//    }
    
    private func setupView() {
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
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct DiaryEditViewController_Preview: PreviewProvider {
    static var previews: some View {
        DiaryEditViewController().showPreview(.iPhone14Pro)
    }
}
#endif
