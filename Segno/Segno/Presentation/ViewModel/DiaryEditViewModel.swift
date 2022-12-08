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
    let imageUseCase: ImageUseCase
    
    var isSearching = BehaviorSubject(value: false)
    var isReceivingLocation = BehaviorSubject(value: false)
    var musicInfo = BehaviorSubject<MusicInfoResult?>(value: nil)
    
    init(diaryEditUseCase: DiaryEditUseCase = DiaryEditUseCaseImpl(),
         diaryDetailUseCase: DiaryDetailUseCase = DiaryDetailUseCaseImpl(),
         searchMusicUseCase: SearchMusicUseCase = SearchMusicUseCaseImpl(),
         locationUseCase: LocationUseCase = LocationUseCaseImpl(),
         imageUseCase: ImageUseCase = ImageUseCaseImpl()) {
        self.diaryEditUseCase = diaryEditUseCase
        self.diaryDetailUseCase = diaryDetailUseCase
        self.searchMusicUseCase = searchMusicUseCase
        self.locationUseCase = locationUseCase
        self.imageUseCase = imageUseCase
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
                $1 ? self.locationUseCase.getLocation() : self.locationUseCase.stopLocation()
            })
            .disposed(by: disposeBag)
        
        locationUseCase.locationSubject
            .bind(to: locationSubject)
            .disposed(by: disposeBag)
        
        locationUseCase.addressSubject
            .bind(to: addressSubject)
            .disposed(by: disposeBag)
    }
    
    func startSearchingMusic() {
        searchMusicUseCase.startSearching()
    }
    
    func stopSearchingMusic() {
        searchMusicUseCase.stopSearching()
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
                                      token: "A1lmMjb2pgNWg6ZzAaPYgMcqRv/8BOyO4U/ui6i/Ic4=")
        }
        // music data가 없는 경우
        else {
            newDiary = NewDiaryDetail(title: title,
                                      tags: tags,
                                      imagePath: imageName,
                                      bodyText: body,
                                      musicInfo: nil,
                                      location: location,
                                      token: "A1lmMjb2pgNWg6ZzAaPYgMcqRv/8BOyO4U/ui6i/Ic4=")
        }
        
        diaryEditUseCase.postDiary(newDiary)
            .subscribe(onSuccess: { newDiaryDetail in
                debugPrint("전송 성공, 결과 : ", newDiaryDetail)
            })
            .disposed(by: disposeBag)
    }
}
