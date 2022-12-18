//
//  DiaryDetailViewController.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/22.
//

import UIKit

import MarqueeLabel
import RxCocoa
import RxSwift
import SnapKit

protocol DiaryDetailViewDelegate: AnyObject {
    func mapButtonTapped(viewController: UIViewController, location: Location)
    func editButtonTapped(diaryData: DiaryDetail?)
    func escapeToCollectionView()
}

final class DiaryDetailViewController: UIViewController {
    // MARK: - Namespaces
    private enum Metric {
        static let stackViewSpacing: CGFloat = 10
        static let stackViewInset: CGFloat = 16
        static let dateFontSize: CGFloat = 17
        static let titleFontSize: CGFloat = 32
        static let textViewFontSize: CGFloat = 24
        static let textViewHeight: CGFloat = 200
        static let textViewInset: CGFloat = 16
        static let tagScrollViewHeight: CGFloat = 30
        static let musicContentViewHeight: CGFloat = 30
        static let locationContentViewHeight: CGFloat = 30
        static let standardCornerRadius: CGFloat = 8
    }
    
    private enum Literal {
        static let textViewPlaceHolder = "내용이 없네요"
        static let musicLibraryDeniedTitle = "음악 접근 권한 설정 필요"
        static let locationEmptyMessage = "저장된 위치가 없습니다."
        static let reportButtonTitle = "신고"
        static let deleteSucceededTitle = "삭제 성공"
        static let deleted = "삭제되었습니다."
        static let errorTitle = "오류!"
        static let failedToDelete = "삭제에 실패했습니다."
        static let reportAlertTitle = "해당 Segno를 신고하시겠습니까?"
        static let reportedTitle = "해당 Segno를 신고하였습니다."
        static let willBeChecked = "관리자가 확인 후 조치하도록 하겠습니다."
        static let confirmDeletingTitle = "해당 Segno를 삭제하시겠습니까?"
    }
    
    // MARK: - Properties
    private let viewModel: DiaryDetailViewModel
    private let localUtilityManager: LocalUtilityManager
    private var disposeBag = DisposeBag()
    private lazy var diaryId: String = ""
    private lazy var diaryUserId: String = ""
    
    weak var delegate: DiaryDetailViewDelegate?
    
    // MARK: - Views
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
        label.font = .systemFont(ofSize: Metric.dateFontSize)
        return label
    }()
    
    private lazy var titleLabel: MarqueeLabel = {
        let label = MarqueeLabel(frame: .zero, rate: 32, fadeLength: 32.0)
        label.font = .appFont(.shiningStar, size: Metric.titleFontSize)
        label.trailingBuffer = 16
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
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .appColor(.color3)
        imageView.layer.cornerRadius = Metric.standardCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .appColor(.grey1)
        textView.font = .appFont(.shiningStar, size: Metric.textViewFontSize)
        textView.isEditable = false
        textView.layer.cornerRadius = Metric.standardCornerRadius
        textView.text = Literal.textViewPlaceHolder
        textView.textColor = .appColor(.label)
        textView.textContainerInset = UIEdgeInsets(top: Metric.textViewInset, left: Metric.textViewInset, bottom: Metric.textViewInset, right: Metric.textViewInset)
        return textView
    }()
    
    private lazy var musicContentView: MusicContentView = {
        let musicContentView = MusicContentView()
        musicContentView.delegate = self
        return musicContentView
    }()
    
    private lazy var locationContentView: LocationContentView = {
        let locationContentView = LocationContentView()
        locationContentView.delegate = self
        return locationContentView
    }()
    
    private lazy var reportBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: Literal.reportButtonTitle, style: .plain, target: self, action: nil)
        item.tintColor = UIColor.appColor(.color4)
        return item
    }()
    
    private lazy var editBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
        item.tintColor = UIColor.appColor(.color4)
        return item
    }()
    
    private lazy var trashBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
        item.tintColor = UIColor.appColor(.color4)
        return item
    }()
    
    // MARK: - Initializers
    init(viewModel: DiaryDetailViewModel,
         localUtilityManager: LocalUtilityManager = LocalUtilityManagerImpl()) {
        self.viewModel = viewModel
        self.localUtilityManager = localUtilityManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bindActions()
        
        bindDiaryItem()
        subscribeAddress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cleanUpTags()
        getDiary()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stopMusic()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Setup view methods
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
    
    private func cleanUpTags() {
        for subview in tagStackView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    // MARK: - Binding action methods
    private func bindActions() {
        reportBarButtonItem.rx.tap
            .withUnretained(self)
            .bind { _ in
                self.reportButtonTapped()
            }
            .disposed(by: disposeBag)
        
        editBarButtonItem.rx.tap
            .withUnretained(self)
            .bind { _ in
                self.editButtonTapped()
            }
            .disposed(by: disposeBag)
        
        trashBarButtonItem.rx.tap
            .withUnretained(self)
            .bind { _ in
                self.trashButtonTapped()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Property subscribing methods
    private func bindDiaryItem() {
        viewModel.idObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] id in
                self?.diaryId = id
            })
            .disposed(by: disposeBag)
        
        viewModel.userIdObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] diaryUserId in
                let userId = self?.localUtilityManager.getToken(key: "userId")
                if userId == diaryUserId {
                    self?.navigationItem.rightBarButtonItems = [self?.trashBarButtonItem ?? UIBarButtonItem(), self?.editBarButtonItem ?? UIBarButtonItem()]
                } else {
                    self?.navigationItem.rightBarButtonItems = [self?.reportBarButtonItem ?? UIBarButtonItem()]
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.dateObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] date in
                self?.dateLabel.text = date
            })
            .disposed(by: disposeBag)
        
        viewModel.titleObservable
            .observe(on: MainScheduler.instance)
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.tagsObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] tags in
                tags.forEach { tagTitle in
                    let tagView = TagView(tagTitle: tagTitle)
                    self?.tagStackView.addArrangedSubview(tagView)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.imagePathObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] imagePath in
                self?.imageView.setImage(imagePath: imagePath)
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
                self?.musicContentView.setMusic(info: musicInfo)
            })
            .disposed(by: disposeBag)
        
        viewModel.locationObservable
            .compactMap { $0 }
            .map { $0.createCLLocation() }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] location in
                self?.locationContentView.setLocation(cllocation: location)
            })
            .disposed(by: disposeBag)
        
        viewModel.locationObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] location in
                if location == nil {
                    self?.locationContentView.mapButton.isEnabled = false
                    self?.locationContentView.locationLabel.text = Literal.locationEmptyMessage
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.addressSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] address in
                self?.locationContentView.locationLabel.text = address
            })
            .disposed(by: disposeBag)
        
        subscribeMusicPlayer()
        subscribeDeleteSucceeded()
    }
    
    // MARK: - Subscribe utilities methods
    private func subscribeMusicPlayer() {
        viewModel.isPlaying
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                self?.musicContentView.changeButtonIcon(isPlaying: status)
            })
            .disposed(by: disposeBag)
        
        viewModel.isReady
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                self?.musicContentView.activatePlayButton(isReady: status)
            })
            .disposed(by: disposeBag)
        
        viewModel.playerErrorStatus
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.makeOKAlert(title: Literal.musicLibraryDeniedTitle, message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribeAddress() {
        viewModel.locationObservable
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] location in
                self?.getAddress(by: location)
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribeDeleteSucceeded() {
        viewModel.isSucceeded
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                if result {
                    self?.makeOKAlert(title: Literal.deleteSucceededTitle, message: Literal.deleted) { _ in
                        self?.delegate?.escapeToCollectionView()
                    }
                } else {
                    self?.makeOKAlert(title: Literal.errorTitle, message: Literal.failedToDelete)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Getting data methods
    private func getDiary() {
        viewModel.getDiary()
    }
    
    private func getAddress(by location: Location) {
        viewModel.getAddress(by: location)
    }
    
    // MARK: - Action methods
    private func reportButtonTapped() {
        makeCancelOKAlert(title: Literal.reportAlertTitle, message: "") { _ in
            self.makeOKAlert(title: Literal.reportedTitle, message: Literal.willBeChecked) { _ in
                self.delegate?.escapeToCollectionView()
            }
        }
    }
    
    private func editButtonTapped() {
        delegate?.editButtonTapped(diaryData: viewModel.diaryData)
    }
    
    private func trashButtonTapped() {
        makeCancelOKAlert(title: Literal.confirmDeletingTitle, message: "") { _ in
            self.viewModel.deleteDiary(id: self.diaryId)
        }
    }
}

extension DiaryDetailViewController: MusicContentViewDelegate {
    // MARK: Music content view method
    func playButtonTapped() {
        viewModel.toggleMusicPlayer()
    }
}

extension DiaryDetailViewController: LocationContentViewDelegate {
    // MARK: - Location content view method
    func mapButtonTapped(location: Location) {
        delegate?.mapButtonTapped(viewController: self, location: location)
    }
}

// MARK: - Preview methods
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct DiaryDetailViewController_Preview: PreviewProvider {
    static var previews: some View {
        DiaryDetailViewController(viewModel: DiaryDetailViewModel(itemIdentifier: "0")).showPreview(.iPhone14Pro)
    }
}
#endif
