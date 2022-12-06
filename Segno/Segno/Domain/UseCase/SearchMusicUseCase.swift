//
//  SearchMusicUseCase.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/01.
//

import RxSwift

protocol SearchMusicUseCase {
    func toggleSearching()
}

final class SearchMusicUseCaseImpl: SearchMusicUseCase {
    let musicRepository: MusicRepository
    
    init(musicRepository: MusicRepository = MusicRepositoryImpl()) {
        self.musicRepository = musicRepository
    }
    
    func toggleSearching() {
        
    }
}
