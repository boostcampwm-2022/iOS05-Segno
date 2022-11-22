//
//  DiaryDetailViewController.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/22.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class DiaryDetailViewController: UIViewController {
    private enum Metric {
        static let textViewPlaceHolder: String = "내용을 입력하세요."
    }
    
    let disposeBag = DisposeBag()
//    private let viewModel: DiaryDetailViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemPink
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .systemYellow
        stackView.spacing = 10
        return stackView
    }()
    
    private let datelabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        return label
    }()
    
    private let tagScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemMint
        return scrollView
    }()
    
    private let tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .systemBrown
        stackView.spacing = 20
        return stackView
    }()
    
    private var tagViews: [UIView] = []
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemGray5
        textView.text = Metric.textViewPlaceHolder
        textView.textColor = .gray
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTemporaryData()
        setupLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        [datelabel, titleLabel, tagScrollView, imageView, textView].forEach {
            stackView.addArrangedSubview($0)
        }
        tagScrollView.addSubview(tagStackView)
        
        tagViews.forEach {
            tagStackView.addArrangedSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        tagScrollView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        tagStackView.snp.makeConstraints {
            $0.edges.equalTo(tagScrollView)
            $0.height.equalTo(tagScrollView.snp.height)
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(view.snp.width)
            
        }
        
        textView.delegate = self
        textView.snp.makeConstraints {
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(100)
        }
    }
    
    private func setTemporaryData() {
        datelabel.text = "11월 22일 14:54"
        titleLabel.text = "서현에서"
        
        let tagView1 = TagView(tagTitle: "음악")
        let tagView2 = TagView(tagTitle: "휴식")
        let tagView3 = TagView(tagTitle: "강릉 여행")
        [tagView1, tagView2, tagView3].forEach {
            tagViews.append($0)
        }
    }
    
    
}

extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Metric.textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = Metric.textViewPlaceHolder
            textView.textColor = .gray
        }
    }
}

enum DeviceType {
    case iPhone14Pro

    func name() -> String {
        switch self {
        case .iPhone14Pro:
            return "iPhone 14 Pro"
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
extension UIViewController {

    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func showPreview(_ deviceType: DeviceType = .iPhone14Pro) -> some View {
        Preview(viewController: self).previewDevice(PreviewDevice(rawValue: deviceType.name()))
    }
}
#endif

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        DiaryDetailViewController().showPreview(.iPhone14Pro)
    }
}
#endif
