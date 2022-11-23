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
    var diaryID: String? = nil
    
    // TODO: 뷰로부터 적당한 간격 주기
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
        stackView.spacing = 8
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
        imageView.image = UIImage(systemName: "popcorn")
        imageView.backgroundColor = .systemMint // 테스트용 색상
        return imageView
    }()
    
    private lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemCyan // 테스트용 색상
        return textView
    }()
    
    // 태그 스택 뷰 - 태그의 관리를 어떻게 할 것인가? 
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
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var addTagButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black // 테스트용 색상..?
        button.layer.cornerRadius = 8
        button.setTitle("+", for: .normal)
        return button
    }()
    
    // 음악 검색 버튼과 음악 제목 레이블
    // 위치 검색 버튼과 위치 레이블
    
    init(diary: DiaryDetail?) {
        super.init(nibName: nil, bundle: nil)
        
        if let diary {
            diaryID = diary.id
            titleTextField.text = diary.title
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // 내비게이션 바 세팅
    
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
            $0.height.equalTo(60)
        }
        
        contentsStackView.addArrangedSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.height.equalTo(400)
        }
        
        contentsStackView.addArrangedSubview(bodyTextView)
        bodyTextView.snp.makeConstraints {
            $0.height.equalTo(400)
        }
        
        contentsStackView.addArrangedSubview(tagScrollView)
        tagScrollView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        setupTagScrollView()
    }
    
    private func setupTagScrollView() {
        tagScrollView.addSubview(tagStackView)
        tagStackView.snp.makeConstraints {
            $0.edges.equalTo(tagScrollView)
            $0.height.equalTo(tagScrollView)
        }
        
        
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
