//
//  DiaryEditViewModel.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/06.
//

import RxSwift

final class DiaryEditViewModel {
    var diaryDetail: DiaryDetail?
    // 에딧 화면에 들어갈 여러 요소들
    
    let diaryDetailUseCase: DiaryDetailUseCase
    let searchMusicUseCase: SearchMusicUseCase
    // 위치 검색 유즈케이스
    
    init(diaryDetailUseCase: DiaryDetailUseCase = DiaryDetailUseCaseImpl(),
         searchMusicUseCase: SearchMusicUseCase = SearchMusicUseCaseImpl()) {
        self.diaryDetailUseCase = diaryDetailUseCase
        self.searchMusicUseCase = searchMusicUseCase
    }
    
    func addTags() {
        
    }
    
    func startSearchingMusic() -> Single<MusicInfo> {
        return searchMusicUseCase.startSearching()
    }
    
    func stopSearchingMusic() {
        searchMusicUseCase.stopSearching()
    }
    
    func setLocation() {
        
    }
    
    func saveDiary() {
        
    }
}