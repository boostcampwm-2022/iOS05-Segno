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
    let getAddressUseCase: GetAddressUseCase
    
    var diaryItem = PublishSubject<DiaryDetail>()
    var addressSubject = PublishSubject<String>()
    var isPlaying = BehaviorSubject(value: false)
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
         getAddressUseCase: GetAddressUseCase = GetAddressUseCaseImpl()
    ) {
        self.itemIdentifier = itemIdentifier
        self.getDetailUseCase = getDetailUseCase
        self.playMusicUseCase = playMusicUseCase
        self.getAddressUseCase = getAddressUseCase
        
        debugPrint(itemIdentifier)
        setupMusicPlayer()
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
        guard let status = try? isPlaying.value() else {
            return
        }
        
        status ? isPlaying.onNext(false) : isPlaying.onNext(true)
        playMusicUseCase.togglePlayer()
    }
    
    func stopMusic() {
        isPlaying.onNext(false)
        playMusicUseCase.stopPlaying()
    }
    
    func getAddress(by location: Location) {
        getAddressUseCase.getAddress(by: location)
    }
}
