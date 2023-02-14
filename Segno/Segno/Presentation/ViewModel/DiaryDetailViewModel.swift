//
//  DiaryDetailViewModel.swift
//  Segno
//
//  Created by YOONJONG on 2022/11/23.
//

import Foundation

import RxSwift

final class DiaryDetailViewModel {
    
    private let itemIdentifier: String
    private let getDetailUseCase: DiaryDetailUseCase
    private let checkSubscriptionUseCase: CheckSubscriptionUseCase
    private let playMusicUseCase: PlayMusicUseCase
    private let settingsUseCase: SettingsUseCase
    private let getAddressUseCase: GetAddressUseCase
    private var diaryItem = PublishSubject<DiaryDetail>()
    
    var diaryData: DiaryDetail?
    var addressSubject = PublishSubject<String>()
    var isPlaying = BehaviorSubject(value: false)
    var isReady = BehaviorSubject(value: false)
    var playerErrorStatus = PublishSubject<MusicError>()
    var isSucceeded = PublishSubject<Bool>()
    lazy var dateObservable = diaryItem.map { $0.date }
    lazy var idObservable = diaryItem.map { $0.identifier }
    lazy var userIdObservable = diaryItem.map { $0.userId }
    lazy var titleObservable = diaryItem.map { $0.title }
    lazy var tagsObservable = diaryItem.map { $0.tags }
    lazy var imagePathObservable = diaryItem.map { $0.imagePath }
    lazy var bodyObservable = diaryItem.map { $0.bodyText }
    lazy var musicObservable = diaryItem.map { $0.musicInfo }
    lazy var locationObservable = diaryItem.map { $0.location }
        
    private var disposeBag = DisposeBag()
    
    init(itemIdentifier: String,
         getDetailUseCase: DiaryDetailUseCase = DiaryDetailUseCaseImpl(),
         checkSubscriptionUseCase: CheckSubscriptionUseCase = CheckSubscriptionUseCaseImpl(),
         playMusicUseCase: PlayMusicUseCase = PlayMusicUseCaseImpl(),
         getAddressUseCase: GetAddressUseCase = GetAddressUseCaseImpl(),
         settingsUseCase: SettingsUseCase = SettingsUseCaseImpl()) {
        self.itemIdentifier = itemIdentifier
        self.getDetailUseCase = getDetailUseCase
        self.checkSubscriptionUseCase = checkSubscriptionUseCase
        self.playMusicUseCase = playMusicUseCase
        self.getAddressUseCase = getAddressUseCase
        self.settingsUseCase = settingsUseCase
        
        subscribePlayingStatus()
        subscribeDownloadStatus()
        subscribePlayerError()
        setupMusicPlayer()
        autoPlay()
        bindAddress()
    }
    
    func getDiary() {
        getDetailUseCase.getDiary(id: itemIdentifier)
            .subscribe(onSuccess: { [weak self] diary in
                self?.diaryItem.onNext(diary)
                self?.diaryData = diary
            }, onFailure: { error in
                debugPrint(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func setupMusicPlayer() {
        musicObservable
            .subscribe(onNext: { [weak self] music in
                self?.playMusicUseCase.setupPlayer(music)
            })
            .disposed(by: disposeBag)
    }
    
    func checkAppleMusicSubscription() {
        checkSubscriptionUseCase.isSubscribedToAppleMusic()
            .subscribe(onCompleted: { [weak self] in
                self?.toggleMusicPlayer()
            }, onError: { [weak self] error in
                self?.playerErrorStatus.onNext(error as? MusicError ?? .unknown)
            })
            .disposed(by: disposeBag)
    }
    
    func toggleMusicPlayer() {
        playMusicUseCase.togglePlayer()
    }
    
    func stopMusic() {
        playMusicUseCase.stopPlaying()
    }
    
    func subscribePlayingStatus() {
        playMusicUseCase.subscribePlayingStatus()
            .subscribe(onNext: { [weak self] status in
                self?.isPlaying.onNext(status)
            })
            .disposed(by: disposeBag)
    }
    
    func subscribeDownloadStatus() {
        playMusicUseCase.subscribeDownloadStatus()
            .subscribe(onNext: { [weak self] status in
                self?.isReady.onNext(status)
            })
            .disposed(by: disposeBag)
    }
    
    func subscribePlayerError() {
        playMusicUseCase.subscribePlayerError()
            .subscribe(onNext: { [weak self] error in
                self?.playerErrorStatus.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    func autoPlay() {
        switch settingsUseCase.getAutoPlayMode() {
        case true:
            subscribeAutoPlay()
        case false:
            return
        }
    }
    
    func subscribeAutoPlay() {
        isReady
            .subscribe(onNext: { [weak self] status in
                if status == true {
                    self?.toggleMusicPlayer()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func getAddress(by location: Location) {
        getAddressUseCase.getAddress(by: location)
    }
    
    func bindAddress() {
        getAddressUseCase.addressSubject
            .bind(to: addressSubject)
            .disposed(by: disposeBag)
    }
    
    func deleteDiary(id: String) {
        getDetailUseCase.deleteDiary(id: id)
            .subscribe(onCompleted: { [weak self] in
                debugPrint("delete 성공")
                self?.isSucceeded.onNext(true)
            }, onError: { [weak self] _ in
                debugPrint("delete 실패")
                self?.isSucceeded.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}
