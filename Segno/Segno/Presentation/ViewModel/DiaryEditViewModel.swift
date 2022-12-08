//
//  DiaryEditViewModel.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/06.
//

import Foundation

import RxSwift

final class DiaryEditViewModel {
    var locationSubject = PublishSubject<Location>()
    var addressSubject = PublishSubject<String>()
    var imageSubject = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    var diaryDetail: DiaryDetail?
    // 에딧 화면에 들어갈 여러 요소들
    
    let diaryDetailUseCase: DiaryDetailUseCase
    let searchMusicUseCase: SearchMusicUseCase
    let locationUseCase: LocationUseCase
    let imageUseCase: ImageUseCase
    
    var isSearching = BehaviorSubject(value: false)
    var isReceivingLocation = BehaviorSubject(value: false)
    var musicInfo = PublishSubject<MusicInfoResult>()
    
    init(diaryDetailUseCase: DiaryDetailUseCase = DiaryDetailUseCaseImpl(),
         searchMusicUseCase: SearchMusicUseCase = SearchMusicUseCaseImpl(),
         locationUseCase: LocationUseCase = LocationUseCaseImpl(),
         imageUseCase: ImageUseCase = ImageUseCaseImpl()) {
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
    
    private func subscribeSearchResult() {
        searchMusicUseCase.musicInfoResult
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
    
    func saveDiary() {
        
    }
    
    func uploadImage(data: Data) {
        imageUseCase.uploadImage(data: data)
            .subscribe(onSuccess: { [weak self] imageInfo in
                guard let filename = imageInfo.filename else { return }
                debugPrint(filename)
                self?.imageSubject.onNext(filename)
            })
            .disposed(by: disposeBag)
    }
}
