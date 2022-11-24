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
        static let majorComponentHeight = 400
        static let minorComponentHeight = 60
        static let tagHeight = 30
        
        static let buttonCornerRadius = CGFloat(minorComponentHeight / 2)
        static let tagButtonCornerRadius = CGFloat(tagHeight / 2)
    }
    
    var diaryID: String?
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemPink // 테스트용 색상
        return scrollView
    }()
    
    // TODO: 뷰로부터 적당한 간격 주기 (일종의 padding이 필요합니다.)
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
        textField.placeholder = "제목을 입력하세요"
        return textField
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo")
        imageView.backgroundColor = .systemMint // 테스트용 색상
        return imageView
    }()
    
    private lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemCyan // 테스트용 색상
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
        button.setImage(UIImage(systemName: "music.note"), for: .normal)
        return button
    }()
    
    private lazy var musicInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 이 음악은 뭘까요?"
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
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        return button
    }()
    
    private lazy var locationInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "여기는 어디인가요?"
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
    
    init(diary: DiaryDetail?) {
        super.init(nibName: nil, bundle: nil)
        
        diaryID = diary?.identifier
        titleTextField.text = diary?.title
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
            $0.width.equalTo(mainScrollView)
        }
        
        setupContentsStackView()
    }
    
    private func setupContentsStackView() {
        contentsStackView.addArrangedSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.height.equalTo(Metric.minorComponentHeight)
        }
        
        contentsStackView.addArrangedSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.height.equalTo(Metric.majorComponentHeight)
        }
        
        contentsStackView.addArrangedSubview(bodyTextView)
        bodyTextView.snp.makeConstraints {
            $0.height.equalTo(Metric.majorComponentHeight)
        }
        
        contentsStackView.addArrangedSubview(tagScrollView)
        tagScrollView.snp.makeConstraints {
            $0.height.equalTo(Metric.tagHeight)
        }
        setupTagScrollView()
        
        contentsStackView.addArrangedSubview(musicStackView)
        musicStackView.snp.makeConstraints {
            $0.height.equalTo(Metric.minorComponentHeight)
        }
        setupMusicStackView()
        
        contentsStackView.addArrangedSubview(locationStackView)
        locationStackView.snp.makeConstraints {
            $0.height.equalTo(Metric.minorComponentHeight)
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
            $0.width.equalTo(Metric.minorComponentHeight)
        }
        musicStackView.addArrangedSubview(musicInfoLabel)
    }
    
    private func setupLocationStackView() {
        locationStackView.addArrangedSubview(addlocationButton)
        addlocationButton.snp.makeConstraints {
            $0.width.equalTo(Metric.minorComponentHeight)
        }
        locationStackView.addArrangedSubview(locationInfoLabel)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct DiaryEditViewController_Preview: PreviewProvider {
    static var previews: some View {
        DiaryEditViewController(diary: nil).showPreview(.iPhone14Pro)
    }
}
#endif
