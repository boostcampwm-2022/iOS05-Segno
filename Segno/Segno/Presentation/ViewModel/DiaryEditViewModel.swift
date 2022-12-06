//
//  DiaryEditViewModel.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/06.
//

import RxSwift

final class DiaryEditViewModel {
    private let disposeBag = DisposeBag()
    var diaryDetail: DiaryDetail?
    // 에딧 화면에 들어갈 여러 요소들
    
    let diaryDetailUseCase: DiaryDetailUseCase
    let searchMusicUseCase: SearchMusicUseCase
    // 위치 검색 유즈케이스
    
    var isSearching = BehaviorSubject(value: false)
    var musicInfo = PublishSubject<MusicInfoResult>()
    
    init(diaryDetailUseCase: DiaryDetailUseCase = DiaryDetailUseCaseImpl(),
         searchMusicUseCase: SearchMusicUseCase = SearchMusicUseCaseImpl()) {
        self.diaryDetailUseCase = diaryDetailUseCase
        self.searchMusicUseCase = searchMusicUseCase
        
        subscribeSearchingStatus()
    }
    
    func addTags() {
        
    }
    
    func toggleSearchMusic() {
        guard let value = try? isSearching.value() else {
            return
        }
        
        value ? isSearching.onNext(false) : isSearching.onNext(true)
    }
    
    func subscribeSearchingStatus() {
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
        searchMusicUseCase.musicInfoResult
            .subscribe(onNext: {
                self.musicInfo.onNext($0)
            })
            .disposed(by: disposeBag)
    }
    
    func setLocation() {
        
    }
    
    func saveDiary() {
        
    }
}
