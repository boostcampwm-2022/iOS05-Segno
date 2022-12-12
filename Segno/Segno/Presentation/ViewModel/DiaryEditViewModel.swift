//
//  DiaryEditViewModel.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/06.
//

import Foundation

import RxSwift

final class DiaryEditViewModel {
    var locationSubject = BehaviorSubject<Location?>(value: nil)
    var addressSubject = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    var diaryDetail: DiaryDetail?
    // 에딧 화면에 들어갈 여러 요소들
    
    let diaryEditUseCase: DiaryEditUseCase
    let diaryDetailUseCase: DiaryDetailUseCase
    let searchMusicUseCase: SearchMusicUseCase
    let locationUseCase: LocationUseCase
    let getAddressUseCase: GetAddressUseCase
    let imageUseCase: ImageUseCase
    let localUtilityRepository: LocalUtilityRepository
    
    var isSearching = BehaviorSubject(value: false)
    var isReceivingLocation = BehaviorSubject(value: false)
    var musicInfo = BehaviorSubject<MusicInfoResult?>(value: nil)
    var isSucceed = PublishSubject<Bool>()
    
    init(diaryEditUseCase: DiaryEditUseCase = DiaryEditUseCaseImpl(),
         diaryDetailUseCase: DiaryDetailUseCase = DiaryDetailUseCaseImpl(),
         searchMusicUseCase: SearchMusicUseCase = SearchMusicUseCaseImpl(),
         locationUseCase: LocationUseCase = LocationUseCaseImpl(),
         getAddressUseCase: GetAddressUseCase = GetAddressUseCaseImpl(),
         imageUseCase: ImageUseCase = ImageUseCaseImpl(),
         localUtilityRepository: LocalUtilityRepository = LocalUtilityRepositoryImpl()) {
        self.diaryEditUseCase = diaryEditUseCase
        self.diaryDetailUseCase = diaryDetailUseCase
        self.searchMusicUseCase = searchMusicUseCase
        self.locationUseCase = locationUseCase
        self.getAddressUseCase = getAddressUseCase
        self.imageUseCase = imageUseCase
        self.localUtilityRepository = localUtilityRepository
        subscribeSearchingStatus()
        subscribeSearchResult()
        subscribeLocation()
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
            .subscribe(onNext: {
                self.toggleSearchMusic()
                self.musicInfo.onNext($0)
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
        let location = try? locationSubject.value()
        var newDiary: NewDiaryDetail
        // music data가 있는 경우
        if let musicInfoResult = try? musicInfo.value(),
           let musicInfo = try? musicInfoResult.get() {
            newDiary = NewDiaryDetail(title: title,
                                      tags: tags,
                                      imagePath: imageName,
                                      bodyText: body,
                                      musicInfo: musicInfo,
                                      location: location,
                                      token: localUtilityRepository.getToken())
        }
        // music data가 없는 경우
        else {
            newDiary = NewDiaryDetail(title: title,
                                      tags: tags,
                                      imagePath: imageName,
                                      bodyText: body,
                                      musicInfo: nil,
                                      location: location,
                                      token: localUtilityRepository.getToken())
        }
        
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
