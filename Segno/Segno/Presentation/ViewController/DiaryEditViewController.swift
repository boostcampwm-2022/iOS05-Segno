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
        static let bodyContentHeight: CGFloat = 200
        static let minorContentHeight: CGFloat = 60
        static let semiMinorContentHeight: CGFloat = 40
        static let halfMinorContentHeight: CGFloat = 30
        static let standardCornerRadius: CGFloat = 8
        static let mediumFontSize: CGFloat = 24
        static let smallFontSize: CGFloat = 16
        static let textFieldFontSize: CGFloat = 12
        static let padding: CGFloat = 12
        static let titlePlaceholder = "제목을 입력하세요."
        static let pickerActionSheetTitle = "옵션 선택"
        static let pickerActionSheetMessage = "원하는 옵션을 선택하세요."
        static let libaryText = "앨범"
        static let cameraText = "카메라"
        static let cancelText = "취소"
        static let bodyPlaceholder = "내용을 입력하세요."
        static let musicPlaceholder = "지금 이 음악은 뭘까요?"
        static let searching = "검색 중입니다..."
        static let musicNotFound = "음악을 찾지 못했어요."
        static let locationPlaceholder = "여기는 어디인가요?"
        static let tagPlaceholder = "태그를 입력해주세요. enter로 태그를 구분합니다."
        static let imageViewStockImage = UIImage(systemName: "photo")
        static let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: padding, height: 0.0))
        // 스택 뷰 안에 들어가는 버튼 설정
        static let musicButtonImage = UIImage(systemName: "music.note")
        static let locationButtonImage = UIImage(systemName: "location.fill")
        static let saveButtonTitle = "저장"
        static let buttonCornerRadius = CGFloat(minorContentHeight / 2)
        static let halfMinorCornerRadius = CGFloat(halfMinorContentHeight / 2)
        static let semiMinorCornerRadius = CGFloat(semiMinorContentHeight / 2)
    }
    
    private let viewModel: DiaryEditViewModel
    private var disposeBag = DisposeBag()
    private var tags: [String] = []
    private var location: Location?
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
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
        textField.font = .systemFont(ofSize: Metric.mediumFontSize)
        textField.placeholder = Metric.titlePlaceholder
        return textField
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .appColor(.color4)
        imageView.contentMode = .scaleAspectFit
        imageView.image = Metric.imageViewStockImage
        imageView.tintColor = .appColor(.white)
        imageView.layer.cornerRadius = Metric.standardCornerRadius
        return imageView
    }()
    
    private lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .appColor(.color2)
        textView.font = .appFont(.shiningStar, size: Metric.mediumFontSize)
        textView.text = Metric.bodyPlaceholder
        textView.textColor = .appColor(.grey3)
        textView.layer.cornerRadius = Metric.standardCornerRadius
        textView.textContainerInset = .init(top: Metric.padding, left: Metric.padding, bottom: Metric.padding, right: Metric.padding)
        textView.delegate = self
        return textView
    }()
    
    private lazy var tagTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .appColor(.grey1)
        textField.placeholder = Metric.tagPlaceholder
        textField.leftView = Metric.leftView
        textField.leftViewMode = .always
        textField.font = .systemFont(ofSize: Metric.textFieldFontSize)
        textField.layer.cornerRadius = Metric.standardCornerRadius
        textField.delegate = self
        return textField
    }()
    
    private lazy var tagScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
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
    
    private lazy var musicStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .appColor(.grey1)
        stackView.distribution = .equalSpacing
        stackView.layer.cornerRadius = Metric.buttonCornerRadius
        stackView.spacing = Metric.doubleSpacing
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: Metric.padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var addMusicButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appColor(.color3)
        button.layer.cornerRadius = Metric.buttonCornerRadius
        button.tintColor = .appColor(.white)
        button.setImage(Metric.musicButtonImage, for: .normal)
        return button
    }()
    
    private lazy var musicInfoLabel: MarqueeLabel = {
        let label = MarqueeLabel(frame: .zero, rate: 32, fadeLength: 32.0)
        label.font = .systemFont(ofSize: Metric.smallFontSize)
        label.text = Metric.musicPlaceholder
        label.trailingBuffer = 16.0
        return label
    }()
    
    private lazy var locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .appColor(.grey1)
        stackView.distribution = .equalSpacing
        stackView.layer.cornerRadius = Metric.buttonCornerRadius
        stackView.spacing = Metric.doubleSpacing
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: Metric.padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var addlocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appColor(.color3)
        button.layer.cornerRadius = Metric.buttonCornerRadius
        button.tintColor = .appColor(.white)
        button.setImage(Metric.locationButtonImage, for: .normal)
        return button
    }()
    
    private lazy var locationInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Metric.smallFontSize)
        label.text = Metric.locationPlaceholder
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appColor(.color4)
        button.layer.cornerRadius = Metric.semiMinorCornerRadius
        button.setTitle(Metric.saveButtonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Metric.smallFontSize)
        return button
    }()
    
    private lazy var photoImageViewTapGesture = UITapGestureRecognizer()
    
    private let imagePicker = UIImagePickerController()
    
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
        setImagePicker()
        setRecognizer()
        bindButtonAction()
        subscribeSearchingStatus()
        subscribeSearchResult()
        subscribeSearchError()
        subscribeLocationResult()
        subscribeEditSucceed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        registerForKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
        removeRegisterForKeyboardNotification()
        viewModel.stopLocation()
    }
    
    private func setupView() {
        view.backgroundColor = .appColor(.background)
        
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
            $0.height.equalTo(Metric.bodyContentHeight)
        }
        
        contentsStackView.addArrangedSubview(tagTextField)
        tagTextField.snp.makeConstraints {
            $0.height.equalTo(Metric.semiMinorContentHeight)
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
        saveButton.snp.makeConstraints {
            $0.height.equalTo(Metric.semiMinorContentHeight)
        }
    }
    
    private func setupTagScrollView() {
        tagScrollView.addSubview(tagStackView)
        tagStackView.snp.makeConstraints {
            $0.edges.equalTo(tagScrollView)
            $0.height.equalTo(tagScrollView)
        }
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
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(photoImageViewTapGesture)
        photoImageViewTapGesture.rx.event
            .bind(onNext: { recognizer in
                self.view.endEditing(true)
                self.presentPickerActionSheet()
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
        
        addlocationButton.rx.tap
            .withUnretained(self)
            .bind { _ in
                self.locationButtonTapped()
            }
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .withUnretained(self)
            .bind { _ in
                if self.photoImageView.image == nil {
                    debugPrint("이미지를 넣지 않으면 저장할 수 없습니다!")
                } else {
                    self.saveDiary()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func presentPickerActionSheet() {
        let alert = UIAlertController(title: Metric.pickerActionSheetTitle, message: Metric.pickerActionSheetMessage, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: Metric.libaryText, style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }
        let cameraAction = UIAlertAction(title: Metric.cameraText, style: .default) { _ in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true)
        }
        let cancelAction = UIAlertAction(title: Metric.cancelText, style: .cancel)
        alert.addAction(libraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func setImagePicker() {
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    private func setRecognizer() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapMethod))
        mainScrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeRegisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func keyboardAnimate(keyboardRectangle: CGRect, frame: CGRect) {
        let contentInset: UIEdgeInsets = .init(
            top: 0,
            left: 0,
            bottom: keyboardRectangle.size.height,
            right: 0
        )
        mainScrollView.contentInset = contentInset
        mainScrollView.scrollIndicatorInsets = contentInset
        mainScrollView.scrollRectToVisible(frame, animated: true)
    }
    
    @objc private func singleTapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    @objc private func keyboardHide(_ notification: Notification) {
        mainScrollView.contentInset = UIEdgeInsets.zero
        mainScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc private func keyboardShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        guard let keyboardFrame: CGRect = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? CGRect else { return }
        

        if bodyTextView.isFirstResponder {
            keyboardAnimate(keyboardRectangle: keyboardFrame, frame: bodyTextView.frame)
        } else if tagTextField.isFirstResponder {
            keyboardAnimate(keyboardRectangle: keyboardFrame, frame: tagScrollView.frame)
        }
    }
}

// 샤잠킷 로직 부분
extension DiaryEditViewController {
    private func subscribeSearchingStatus() {
        viewModel.isSearching
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { searchState in
                switch searchState {
                case true:
                    self.musicInfoLabel.text = Metric.searching
                case false:
                    self.musicInfoLabel.text = Metric.musicPlaceholder
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribeSearchResult() {
        viewModel.musicInfoResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let song = self?.viewModel.musicInfo else { return }
                let title = song.title
                let artist = song.artist
                
                debugPrint(song)
                
                self?.musicInfoLabel.text = "\(artist) - \(title)"
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribeSearchError() {
        viewModel.searchError
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.makeOKAlert(title: "Error!", message: error.errorDescription) { _ in
                    self?.musicInfoLabel.text = Metric.musicNotFound
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func searchTapped() {
        viewModel.toggleSearchMusic()
    }
    
    private func subscribeEditSucceed() {
        viewModel.isSucceed
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                // TODO: Coordinator로 이동
                if result {
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    // TODO: 알럿
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func locationButtonTapped() {
        viewModel.toggleLocation()
    }
    
    private func saveDiary() {
        guard photoImageView.image != Metric.imageViewStockImage else {
            makeOKAlert(title: "사진이 없습니다.", message: "사진은 필수 입력 항목입니다.")
            return
        }
        
        guard let imageData = photoImageView.image?.jpegData(compressionQuality: 1) else {
            return
        }
        
        guard var title = titleTextField.text else { return }
        if title.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분에 저장된 세뇨입니다."
            dateFormatter.locale = Locale(identifier: "ko_KR")
            title = dateFormatter.string(from: Date())
        }
        
        guard var bodyText = bodyTextView.text else { return }
        if bodyTextView.text == Metric.bodyPlaceholder || bodyTextView.text.isEmpty {
            bodyText = ""
        }
        
        viewModel.saveDiary(title: title, body: bodyText, tags: tags, imageData: imageData)
    }
}


extension DiaryEditViewController {
    private func subscribeLocationResult() {
        viewModel.isReceivingLocation
            .withUnretained(self)
            .subscribe(onNext: { _, searchState in
                switch searchState {
                case true:
                    self.locationInfoLabel.text = Metric.searching
                    self.addlocationButton.tintColor = .systemRed
                case false:
                    self.addlocationButton.tintColor = .appColor(.white)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.addressSubject
            .bind(to: locationInfoLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.locationSubject
            .withUnretained(self)
            .subscribe(onNext: { _, location in
                self.location = location
            })
            .disposed(by: disposeBag)
    }
}
extension DiaryEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        photoImageView.backgroundColor = .clear
        photoImageView.image = newImage
        dismiss(animated: true)
    }
}

extension DiaryEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tagTextField {
            guard let tagText = tagTextField.text, !tagText.isEmpty, !tags.contains(tagText) else {
                return false
            }
            let tagView = TagView(tagTitle: tagText)
            let deleteGesture = DeleteGestureRecognizer(target: self, action: #selector(deleteTagView))
            deleteGesture.title = tagText
            tagView.addGestureRecognizer(deleteGesture)
            
            tags.append(tagText)
            tagStackView.addArrangedSubview(tagView)
            tagTextField.text = nil
        }
        return true
    }
    
    @objc func deleteTagView(sender: DeleteGestureRecognizer) {
        guard let tagTitle = sender.title else { return }
        let tagViews = tagStackView.arrangedSubviews
            .compactMap { $0 as? TagView }
            .filter { $0.tagLabel.text == tagTitle }
        guard let tagView = tagViews.first else { return }
        
        if let index = tags.firstIndex(of: tagTitle) {
            tags.remove(at: index)
        }
        
        tagStackView.removeArrangedSubview(tagView)
        tagView.removeFromSuperview()
    }
}

extension DiaryEditViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Metric.bodyPlaceholder {
            textView.text = nil
            textView.textColor = .appColor(.label)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = Metric.bodyPlaceholder
            textView.textColor = .appColor(.grey3)
        }
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
