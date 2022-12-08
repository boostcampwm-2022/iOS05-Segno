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
    
    let diaryDetailUseCase: DiaryDetailUseCase
    let searchMusicUseCase: SearchMusicUseCase
    let locationUseCase: LocationUseCase
    let imageUseCase: ImageUseCase
    
    var isSearching = BehaviorSubject(value: false)
    var isReceivingLocation = BehaviorSubject(value: false)
    var musicInfo = BehaviorSubject<MusicInfoResult?>(value: nil)
    
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
    
    func saveDiary(title: String, body: String, tags: [String], imageData: Data) {
        imageUseCase.uploadImage(data: imageData)
            .subscribe(onSuccess: { [weak self] imageInfo in
                guard let imageName = imageInfo.filename else { return }
                debugPrint(imageName)
                guard let location = try? self?.locationSubject.value() else { return }
                guard let musicInfoResult = try? self?.musicInfo.value() else { return }
                switch musicInfoResult {
                case .success(let musicInfo):
                    debugPrint(musicInfo)
                    self?.saveDiary(title: title, body: body, tags: tags, imageName: imageName, musicInfo: musicInfo, location: location)
                case .failure(let error):
                    debugPrint(error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func saveDiary(title: String, body: String, tags: [String], imageName: String, musicInfo: MusicInfo, location: Location) {
        debugPrint("저장할 프로퍼티 : \(title), \(body), \(tags), \(imageName), \(musicInfo), \(location)")
    }
}
