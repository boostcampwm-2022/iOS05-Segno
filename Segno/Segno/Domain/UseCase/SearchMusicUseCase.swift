//
//  SearchMusicUseCase.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/01.
//

import RxSwift

typealias MusicInfoResult = Result<MusicInfo, Error>

protocol SearchMusicUseCase {
    var musicInfoResult: PublishSubject<MusicInfoResult> { get set }
    
    func startSearching()
    func stopSearching()
}

final class SearchMusicUseCaseImpl: SearchMusicUseCase {
    let musicRepository: MusicRepository
    var musicInfoResult = PublishSubject<MusicInfoResult>()
    
    init(musicRepository: MusicRepository = MusicRepositoryImpl()) {
        self.musicRepository = musicRepository
    }
    
    func startSearching() {
        
    }
    
    func stopSearching() {
        
    }
}
