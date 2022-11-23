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
        static let stackViewInset: CGFloat = 16
        static let dateFontSize: CGFloat = 17
        static let titleFontSize: CGFloat = 20
        static let textViewFontSize: CGFloat = 16
        static let textViewHeight: CGFloat = 200
        static let textViewInset: CGFloat = 16
        static let tagScrollViewHeight: CGFloat = 30
        static let musicContentViewHeight: CGFloat = 30
        static let locationContentViewHeight: CGFloat = 30
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel: DiaryDetailViewModel
    
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
    
    init(viewModel: DiaryDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bindDiaryItem()
        getDiary()
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
            $0.edges.equalTo(scrollView).inset(Metric.stackViewInset)
            $0.width.equalTo(scrollView.snp.width).inset(Metric.stackViewInset)
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
            $0.width.height.equalTo(stackView.snp.width)
            
        }
        
        textView.delegate = self
        textView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(Metric.textViewHeight)
        }
        
        musicContentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(Metric.musicContentViewHeight)
        }
        
        locationContentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(Metric.locationContentViewHeight)
        }
    }
    
    private func bindDiaryItem() {
        
        dateLabel.text = "11/22 14:54"
        
        viewModel.titleObservable
            .observe(on: MainScheduler.instance)
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.tagsObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] tags in
                tags.forEach { tagTitle in
                    let tagView = TagView(tagTitle: tagTitle)
                    self?.tagViews.append(tagView)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.imagePathObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] imagePath in
                self?.imageView.image = UIImage(named: imagePath)
            })
            .disposed(by: disposeBag)
        
        viewModel.bodyObservable
            .observe(on: MainScheduler.instance)
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.musicObservable
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] musicInfo in
                self?.musicContentView.setMusic(title: musicInfo.title, artist: musicInfo.artist, imageURL: musicInfo.imageURL)
            })
            .disposed(by: disposeBag)
        
        viewModel.locationObservable
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] location in
                self?.locationContentView.setLocation(location: location)
            })
            .disposed(by: disposeBag)
    }
    
    private func getDiary() {
        viewModel.getDiary()
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
        DiaryDetailViewController(viewModel: DiaryDetailViewModel(itemIdentifier: "0")).showPreview(.iPhone14Pro)
    }
}
#endif
