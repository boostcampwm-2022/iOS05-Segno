//
//  SearchMusicUseCase.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/01.
//

import RxSwift

protocol SearchMusicUseCase {
    func searchMusic() -> Single<MusicInfo>
}

final class SearchMusicUseCaseImpl: SearchMusicUseCase {
    func searchMusic() -> Single<MusicInfo> {
        // 음악을 검색해줄 것을 레포지토리에 요청
        
        return Single.create { _ in
            return Disposables.create()
        }
    }
}
