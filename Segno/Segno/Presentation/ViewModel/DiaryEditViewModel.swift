//
//  DiaryEditViewModel.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/06.
//

import Foundation

import RxSwift

final class DiaryEditViewModel {
    private enum Metric {
        static let userToken: String = "userToken"
    }
    
    var locationSubject = BehaviorSubject<Location?>(value: nil)
    var addressSubject = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    private var diaryItem = PublishSubject<DiaryDetail>()
    private var diaryData: DiaryDetail?
    private var isUpdating = false
    
    lazy var idObservable = diaryItem.map { $0.identifier }
    lazy var titleObservable = diaryItem.map { $0.title }
    lazy var tagsObservable = diaryItem.map { $0.tags }
    lazy var imagePathObservable = diaryItem.map { $0.imagePath }
    lazy var bodyObservable = diaryItem.map { $0.bodyText }
    lazy var musicObservable = diaryItem.map { $0.musicInfo }
    lazy var locationObservable = diaryItem.map { $0.location }
    
    let diaryEditUseCase: DiaryEditUseCase
    let diaryDetailUseCase: DiaryDetailUseCase
    let searchMusicUseCase: SearchMusicUseCase
    let locationUseCase: LocationUseCase
    let getAddressUseCase: GetAddressUseCase
    let imageUseCase: ImageUseCase
    let localUtilityManager: LocalUtilityManager
    
    var musicInfo: MusicInfo?
    
    var isSearching = BehaviorSubject(value: false)
    var isReceivingLocation = BehaviorSubject(value: false)
    var musicInfoResult = PublishSubject<MusicInfo>()
    var searchError = PublishSubject<ShazamError>()
    var isSucceed = PublishSubject<Bool>()
    
    init(diaryData: DiaryDetail? = nil,
         diaryEditUseCase: DiaryEditUseCase = DiaryEditUseCaseImpl(),
         diaryDetailUseCase: DiaryDetailUseCase = DiaryDetailUseCaseImpl(),
         searchMusicUseCase: SearchMusicUseCase = SearchMusicUseCaseImpl(),
         locationUseCase: LocationUseCase = LocationUseCaseImpl(),
         getAddressUseCase: GetAddressUseCase = GetAddressUseCaseImpl(),
         imageUseCase: ImageUseCase = ImageUseCaseImpl(),
         localUtilityManager: LocalUtilityManager = LocalUtilityManagerImpl()) {
        self.diaryData = diaryData
        self.diaryEditUseCase = diaryEditUseCase
        self.diaryDetailUseCase = diaryDetailUseCase
        self.searchMusicUseCase = searchMusicUseCase
        self.locationUseCase = locationUseCase
        self.getAddressUseCase = getAddressUseCase
        self.imageUseCase = imageUseCase
        self.localUtilityManager = localUtilityManager
        subscribeSearchingStatus()
        subscribeSearchResult()
        subscribeSearchError()
        subscribeLocation()
        subscribeMusicInfo()
    }
    
    func checkExistingDiary() {
        if let diaryData {
            diaryItem.onNext(diaryData)
            isUpdating = true
        }
    }
    
    func toggleSearchMusic() {
        guard let value = try? isSearching.value() else {
            return
        }
        
        isSearching.onNext(!value)
    }
    
    private func subscribeSearchingStatus() {
        isSearching
            .subscribe(onNext: {
                $0 ? self.startSearchingMusic() : self.stopSearchingMusic()
            })
            .disposed(by: disposeBag)
    }
    
    func startSearchingMusic() {
        searchMusicUseCase.startSearching()
    }
    
    func stopSearchingMusic() {
        searchMusicUseCase.stopSearching()
    }
    
    func subscribeSearchResult() {
        searchMusicUseCase.subscribeShazamResult()
            .subscribe(onNext: { [weak self] result in
                self?.toggleSearchMusic()
                self?.musicInfoResult.onNext(result)
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribeMusicInfo() {
        musicInfoResult
            .subscribe(onNext: { [weak self] info in
                self?.musicInfo = info
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribeSearchError() {
        searchMusicUseCase.subscribeShazamError()
            .subscribe(onNext: { [weak self] error in
                self?.searchError.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribeLocation() {
        isReceivingLocation
            .withUnretained(self)
            .subscribe(onNext: {
                $1 ? self.getLocation() : self.stopLocation()
            })
            .disposed(by: disposeBag)
        
        locationUseCase.locationSubject
            .subscribe(onNext: { [weak self] location in
                self?.locationSubject.onNext(location)
                self?.getAddressUseCase.getAddress(by: location)
            })
            .disposed(by: disposeBag)
        
        getAddressUseCase.addressSubject
            .bind(to: addressSubject)
            .disposed(by: disposeBag)
    }
    
    func toggleLocation() {
        guard let value = try? isReceivingLocation.value() else { return }
        isReceivingLocation.onNext(!value)
    }
    
    func saveDiary(title: String, body: String?, tags: [String], imageData: Data) {
        imageUseCase.uploadImage(data: imageData)
            .subscribe(onSuccess: { [weak self] imageInfo in
                guard let imageName = imageInfo.filename else { return }
                debugPrint("이미지 이름 : ", imageName)
                self?.saveDiary(title: title, body: body, tags: tags, imageName: imageName)
            })
            .disposed(by: disposeBag)
    }
    
    func saveDiary(title: String, body: String?, tags: [String], imageName: String) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년 MM월 dd일 HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko")
        let dateString = dateFormatter.string(from: date)
        let location = try? locationSubject.value() 
        
        let newDiary = NewDiaryDetail(date: dateString,
                                      title: title,
                                      tags: tags,
                                      imagePath: imageName,
                                      bodyText: body,
                                      musicInfo: musicInfo ?? nil,
                                      location: location,
                                      token: localUtilityManager.getToken(key: Metric.userToken))

        diaryEditUseCase.postDiary(newDiary)
            .subscribe(onCompleted: { [weak self] in
                debugPrint("post 성공")
                self?.isSucceed.onNext(true)
            }, onError: { [weak self] _ in
                debugPrint("post 실패")
                self?.isSucceed.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    func getLocation() {
        locationUseCase.getLocation()
    }
    
    func stopLocation() {
        locationUseCase.stopLocation()
    }
}
