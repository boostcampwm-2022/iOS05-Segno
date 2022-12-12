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
    
    var locationSubject = PublishSubject<Location>()
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
    
    let diaryEditUseCase: DiaryEditUseCase
    let diaryDetailUseCase: DiaryDetailUseCase
    let searchMusicUseCase: SearchMusicUseCase
    let locationUseCase: LocationUseCase
    let getAddressUseCase: GetAddressUseCase
    let imageUseCase: ImageUseCase
    let localUtilityManager: LocalUtilityManager
    
    var musicInfo: MusicInfo?
    var locationInfo: Location?
    
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
        subscribeLocationSubject()
    }
    
    func checkExistingDiary() {
        if let diaryData {
            diaryItem.onNext(diaryData)
            isUpdating = true
        }
        
        if let location = diaryData?.location {
            locationSubject.onNext(location)
        }
        
        if let music = diaryData?.musicInfo {
            musicInfo = music
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
                self?.locationInfo = location
            })
            .disposed(by: disposeBag)
        
        getAddressUseCase.addressSubject
            .withUnretained(self)
            .subscribe(onNext: {_, address in
                self.isReceivingLocation.onNext(false)
                self.addressSubject.onNext(address)
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribeLocationSubject() {
        locationSubject
            .subscribe(onNext: { [weak self] location in
                self?.locationInfo = location
                self?.getAddressUseCase.getAddress(by: location)
            })
            .disposed(by: disposeBag)
    }
    
    func toggleLocation() {
        guard let value = try? isReceivingLocation.value() else { return }
        isReceivingLocation.onNext(!value)
    }
    
    func saveDiary(title: String, body: String?, tags: [String], imageData: Data) {
        switch isUpdating {
        case true:
            guard let id = diaryData?.identifier else { return }
            updateDiary(id: id, title: title, body: body, tags: tags, imageData: imageData)
        case false:
            createDiary(title: title, body: body, tags: tags, imageData: imageData)
        }
    }
    
    func createDiary(title: String, body: String?, tags: [String], imageData: Data) {
        imageUseCase.uploadImage(data: imageData)
            .subscribe(onSuccess: { [weak self] imageInfo in
                guard let imageName = imageInfo.filename else { return }
                debugPrint("이미지 이름 : ", imageName)
                self?.createDiary(title: title, body: body, tags: tags, imageName: imageName)
            })
            .disposed(by: disposeBag)
    }
    
    func createDiary(title: String, body: String?, tags: [String], imageName: String) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년 MM월 dd일 HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko")
        let dateString = dateFormatter.string(from: date)
        
        let newDiary = NewDiaryDetail(date: dateString,
                                      title: title,
                                      tags: tags,
                                      imagePath: imageName,
                                      bodyText: body,
                                      musicInfo: musicInfo,
                                      location: locationInfo,
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
    
    func updateDiary(id: String, title: String, body: String?, tags: [String], imageData: Data) {
        imageUseCase.uploadImage(data: imageData)
            .subscribe(onSuccess: { [weak self] imageInfo in
                guard let imageName = imageInfo.filename else { return }
                debugPrint("이미지 이름 : ", imageName)
                self?.updateDiary(id: id, title: title, body: body, tags: tags, imageName: imageName)
            })
            .disposed(by: disposeBag)
    }
    
    func updateDiary(id: String, title: String, body: String?, tags: [String], imageName: String) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년 MM월 dd일 HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko")
        let dateString = dateFormatter.string(from: date)
        
        let diary = UpdateDiaryDetail(id: id,
                                      date: dateString,
                                      title: title,
                                      tags: tags,
                                      imagePath: imageName,
                                      bodyText: body,
                                      musicInfo: musicInfo,
                                      location: locationInfo,
                                      token: localUtilityManager.getToken(key: Metric.userToken))
        
        debugPrint(diary)
        
        diaryEditUseCase.updateDiary(diary)
            .subscribe(onCompleted: { [weak self] in
                debugPrint("update 성공")
                self?.isSucceed.onNext(true)
            }, onError: { [weak self] _ in
                debugPrint("update 실패")
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
    
    func subscribeError() -> Observable<LocationError> {
        return locationUseCase.subscribeError()
    }
}
