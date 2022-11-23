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
        static let stackViewSpacing: CGFloat = 10
        static let dateFontSize: CGFloat = 17
        static let titleFontSize: CGFloat = 20
        static let textViewFontSize: CGFloat = 16
        static let textViewHeight: CGFloat = 200
        static let textViewInset: CGFloat = 16
        static let tagScrollViewHeight: CGFloat = 30
        static let musicContentViewHeight: CGFloat = 30
        static let locationContentViewHeight: CGFloat = 30
    }
    
    let disposeBag = DisposeBag()
//    private let viewModel: DiaryDetailViewModel
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.stackViewSpacing
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.surroundAir, size: Metric.dateFontSize)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .appFont(.surround, size: Metric.titleFontSize)
        return label
    }()
    
    private lazy var tagScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Metric.stackViewSpacing
        return stackView
    }()
    
    private lazy var tagViews: [UIView] = []
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .appColor(.grey1)
        textView.text = Metric.textViewPlaceHolder
        textView.font = .appFont(.shiningStar, size: Metric.textViewFontSize)
        textView.textColor = .appColor(.grey2)
        textView.textContainerInset = UIEdgeInsets(top: Metric.textViewInset, left: Metric.textViewInset, bottom: Metric.textViewInset, right: Metric.textViewInset)
        return textView
    }()
    
    private lazy var musicContentView: MusicContentView = {
        let musicContentView = MusicContentView()
        return musicContentView
    }()
    
    private lazy var locationContentView: LocationContentView = {
        let locationContentView = LocationContentView()
        return locationContentView
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
        view.backgroundColor = .appColor(.background)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        [dateLabel, titleLabel, tagScrollView, imageView, textView, musicContentView, locationContentView].forEach {
            stackView.addArrangedSubview($0)
        }
        tagScrollView.addSubview(tagStackView)
        
        tagViews.forEach {
            tagStackView.addArrangedSubview($0)
        }
                
        
        tagScrollView.snp.makeConstraints {
            $0.height.equalTo(Metric.tagScrollViewHeight)
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
            $0.height.equalTo(Metric.textViewHeight)
        }
        
        musicContentView.snp.makeConstraints {
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(Metric.musicContentViewHeight)
        }
        
        locationContentView.snp.makeConstraints {
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(Metric.locationContentViewHeight)
        }
    }
    
    private func setTemporaryData() {
        dateLabel.text = "11/22 14:54"
        titleLabel.text = "서현에서"
        
        let tagView1 = TagView(tagTitle: "음악")
        let tagView2 = TagView(tagTitle: "휴식")
        let tagView3 = TagView(tagTitle: "코딩코딩")
        [tagView1, tagView2, tagView3].forEach {
            tagViews.append($0)
        }
        musicContentView.setMusic(title: "Comedy", artist: "Gen Hoshino")
        locationContentView.setLocation(location: "경기도 성남시 분당구")
    }
    
    
}

extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Metric.textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .appColor(.black)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = Metric.textViewPlaceHolder
            textView.textColor = .appColor(.grey2)
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
