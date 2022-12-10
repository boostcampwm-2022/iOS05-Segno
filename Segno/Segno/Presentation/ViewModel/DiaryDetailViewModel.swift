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
    let getDetailUseCase: DiaryDetailUseCase
    let playMusicUseCase: PlayMusicUseCase
    let settingsUseCase: SettingsUseCase
    
    var diaryItem = PublishSubject<DiaryDetail>()
    var isPlaying = BehaviorSubject(value: false)
    var playerErrorStatus = PublishSubject<MusicError>()
    
    // TODO: DiaryDetail에 date 추가
    // lazy var dateObservable = diaryItem.map { $0.date }
    lazy var titleObservable = diaryItem.map { $0.title }
    lazy var tagsObservable = diaryItem.map { $0.tags }
    lazy var imagePathObservable = diaryItem.map { $0.imagePath }
    lazy var bodyObservable = diaryItem.map { $0.bodyText }
    lazy var musicObservable = diaryItem.map { $0.musicInfo }
    lazy var locationObservable = diaryItem.map { $0.location }
        
    private let disposeBag = DisposeBag()
    
    init(itemIdentifier: String,
         getDetailUseCase: DiaryDetailUseCase = DiaryDetailUseCaseImpl(),
         playMusicUseCase: PlayMusicUseCase = PlayMusicUseCaseImpl(),
         settingsUseCase: SettingsUseCase = SettingsUseCaseImpl()) {
        self.itemIdentifier = itemIdentifier
        self.getDetailUseCase = getDetailUseCase
        self.playMusicUseCase = playMusicUseCase
        self.settingsUseCase = settingsUseCase
        
        subscribePlayingStatus()
        subscribePlayerError()
        setupMusicPlayer()
        // 오토플레이 메서드를 잠시 후에 실행 (혹은 다운로드가 끝나면 실행)
    }
    
    func testDataInsert() {
        diaryItem.onNext(DiaryDetail.dummy)
    }
    
    func getDiary() {
        getDetailUseCase.getDiary(id: itemIdentifier)
            .subscribe(onSuccess: { [weak self] diary in
                self?.diaryItem.onNext(diary)
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
            debugPrint(true)
            toggleMusicPlayer()
        case false:
            debugPrint(false)
            return
        }
    }
}
